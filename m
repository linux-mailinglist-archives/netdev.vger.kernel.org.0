Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B7B16AA29
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 16:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgBXPd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 10:33:27 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33668 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727359AbgBXPd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 10:33:26 -0500
Received: by mail-lj1-f194.google.com with SMTP id y6so10627658lji.0
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 07:33:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IsWWcPyBf3Yi34lCJhNXBqNSjABC9oJnrYvhguJN/qE=;
        b=FoFsf33IZOWzsyNS7fdSHYnzIKST5V6Kudqlt2JufrGEns68j7i4T1e0+7Km2xoipc
         UQSwhGUlbG+/eOdXXYMgJFqno/85I46tSTjPt61ll43iEYRcdxTRQOcHfVhY3ENf5Bv5
         3JeSo0V8XqdhlbYuaNXG2DKYfM1QYlQZeOb4I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IsWWcPyBf3Yi34lCJhNXBqNSjABC9oJnrYvhguJN/qE=;
        b=YADlDtLZJ4ljqZDRykD8QRTR8nUjexykJLcFrN0zhjzg5mFeIqNOJtNY5htij2vW3Z
         O28UeaZXg3Ek0dfVCYVGxCl+KVYBJeleVlqrCxT0GLP4gLRti2KX1hz3+noOYf20Gscu
         AbPIe5T66I+lmxiSaTqVzlrByyKgmI32ncElYX0sb/sRQjQRaV6kQ4y+byx5gIAZ/fTV
         ufw7cKn0FpAde5nhGWBNSN2EQ8Q9iNMeJXwCpIOIcpyuyNIAlLzb55VDJnDbI1II+Skr
         1DT7o9ISrbEFiU3m/qA+SK0XtOFIcdOH12s1SGFcNgTnaBJ7AJYhwzNX0yRF9+Rq+x+a
         zsAA==
X-Gm-Message-State: APjAAAXzAm+OnaI6Nuf6bYa4kYy2RuWOQ/XxtxqFLggvSgEuirFjJeVH
        O8iaV1837TVOlh4dv+N+b69dZ0oBq6s=
X-Google-Smtp-Source: APXvYqy2zENuYBWFwIPXgaEjxxvxsjiG32ayrIsTzQ0V9kg0nAvD17DFlov68V/fdF5S/3QbipQoXw==
X-Received: by 2002:a2e:9b03:: with SMTP id u3mr31026984lji.87.1582558404519;
        Mon, 24 Feb 2020 07:33:24 -0800 (PST)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 14sm6390845ljj.32.2020.02.24.07.33.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 07:33:23 -0800 (PST)
Subject: Re: [PATCH net] net: bridge: fix stale eth hdr pointer in br_dev_xmit
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org,
        syzbot+18c8b623c66fc198c493@syzkaller.appspotmail.com
References: <08a2e28b-fcf5-b26c-da75-97df67f51c7c@cumulusnetworks.com>
 <20200224130715.1446935-1-nikolay@cumulusnetworks.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <83cadec7-d659-cf2a-c0c0-a85d2f6503bc@cumulusnetworks.com>
Date:   Mon, 24 Feb 2020 17:33:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200224130715.1446935-1-nikolay@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/02/2020 15:07, Nikolay Aleksandrov wrote:
> In br_dev_xmit() we perform vlan filtering in br_allowed_ingress() but
> if the packet has the vlan header inside (e.g. bridge with disabled
> tx-vlan-offload) then the vlan filtering code will use skb_vlan_untag()
> to extract the vid before filtering which in turn calls pskb_may_pull()
> and we may end up with a stale eth pointer. Moreover the cached eth header
> pointer will generally be wrong after that operation. Remove the eth header
> caching and just use eth_hdr() directly, the compiler does the right thing
> and calculates it only once so we don't lose anything.
> 
> Reported-by: syzbot+18c8b623c66fc198c493@syzkaller.appspotmail.com
> Fixes: 057658cb33fb ("bridge: suppress arp pkts on BR_NEIGH_SUPPRESS ports")
> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> ---
>  net/bridge/br_device.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 

Funny but this might turn out to be a totally unrelated bug to the one reported by syzbot.
I just noticed it's saying uninit instead of use-after-free. I'm now building the
whole syz environment mentioned in the report to check it out.
That being said - the bug that I'm fixing here exists, we just might have to drop the
Reported-by: tag if it turns out the uninit bug is a different one. :)

I'll report back when I'm able to reproduce the syz uninit bug.

