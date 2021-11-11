Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3258A44D2B5
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 08:50:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231723AbhKKHxh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 02:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhKKHxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 02:53:33 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F80EC061766;
        Wed, 10 Nov 2021 23:50:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=4HCVFFk19upOjTLWNUM/OfRNFSnFhC8rZPL5tgGbIYE=;
        t=1636617044; x=1637826644; b=lX02yLfzgZEG3RvUVNmrUq3brvZPz/Sddu9O3r/KE3wP593
        k6RPCXWohDWxiCt0nTb02/eymF+eJfJ4hAIIBMqv2AA5YSDfzEuQ7nkApgU4F2goas2IQAAr66Kgz
        o84YXX9RiXgMMbO11adU+9wyIU2sT1IwkpG0hu/SSPu3HA02DCderbhB0tG/3Red3zQdn6juLqT3A
        Ct13Ot1jsvA4bjaHELuB/FSMT/lTurqMUx+PwUvPNULLm5xhyLQHw4lRLIaSsrxXYZq4v0FcCbjHQ
        RRLdBjB0dagHzQd14N+x6l80rT9DajWuLaV4GKgYoRd64x0xL/H7xA5NlegRL4NA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ml4qx-00Dh6U-8K;
        Thu, 11 Nov 2021 08:50:35 +0100
Message-ID: <e6bfbffa089c711fa3ea21f5f8ab852aaa4d9c00.camel@sipsolutions.net>
Subject: Re: [syzbot] WARNING in __dev_change_net_namespace
From:   Johannes Berg <johannes@sipsolutions.net>
To:     syzbot <syzbot+5434727aa485c3203fed@syzkaller.appspotmail.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "avagin@gmail.com" <avagin@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kafai@fb.com" <kafai@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "yhs@fb.com" <yhs@fb.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Thu, 11 Nov 2021 08:50:33 +0100
In-Reply-To: <0000000000008a7c9605d07da846@google.com>
References: <0000000000008a7c9605d07da846@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-11-11 at 06:43 +0000, syzbot wrote:
> 
> console output: https://syzkaller.appspot.com/x/log.txt?x=15b45fb6b00000

So we see that fault injection is triggering a memory allocation failure
deep within the device_rename():

int __dev_change_net_namespace(struct net_device *dev, struct net *net,
                               const char *pat, int new_ifindex)
{
...
        /* Fixup kobjects */
        err = device_rename(&dev->dev, dev->name);
        WARN_ON(err);


So we hit that WARN_ON().

I'm not really sure what to do about that though. Feels like we should
be able to cope with failures here, but clearly we don't, and it seems
like it would also be tricky to do after all the work already done at
this point.

Perhaps device_rename() could grow an API to preallocate all the
memories, but that would also be fairly involved, I imagine?

johannes

