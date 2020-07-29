Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE702316FC
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 02:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730971AbgG2Aw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 20:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730837AbgG2Awz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 20:52:55 -0400
Received: from mail-oo1-xc2f.google.com (mail-oo1-xc2f.google.com [IPv6:2607:f8b0:4864:20::c2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B88CC061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:52:55 -0700 (PDT)
Received: by mail-oo1-xc2f.google.com with SMTP id x1so2017091oox.6
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 17:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=FQKh6BDyrUAvdCbRkRoCWIwTvs02e1A4z4+hyJcCeYc=;
        b=bfMHrDNjRDJzP637Ny1jxdVnVrLBDUP/0SWUTzFX0Fd/EOqUJ7j6mZBax2+ryXNGEK
         8SBRi3zyD7mF/u/4MnKI5U4Sm2UkxG/+xxOQX4ItIYdKgsagKvXvNpVviNZKfIfIbUq1
         urtGTKEPdzepU5y9a49joRcOhTSJNVq5dp7kN2um3WQqfG4ZAzZUfbTP0/44vsJTYiDJ
         ELH7qkipiigniwpJeh+h7YrP/v923b1JqEQ5MjsCMZwe2EDkw6AV0tEmMtD1a1k2/zuX
         VXYamobnaIV+AjdIx4jD/xCNsYsObyVUxfnnBKfl6tJLmtPO04QLl1HDa8fV+bhG/k0n
         325A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=FQKh6BDyrUAvdCbRkRoCWIwTvs02e1A4z4+hyJcCeYc=;
        b=SWXjBsjugnhryvR6fPF0ME5P9UdjNof1X1ppFakO5RSsar2MWFN7Nb0Lhkt8x/ofl4
         OGdF0adRrbuxRD3HbtdaBMCOCToYGeTOUJHv3nRQbDYqFUcLG1Q4JR8wroD1yLxXN8d6
         kw4g5JV8UK/h8avKzU2M9G0VBOZPXrkDWPYFHnJy5WgiU4m8DZfpbI9y8JGhvBBlpSE+
         zGGuQiT9INqn/XQzL5Z7QrXGzlEYodfozk9p9G+jaUh8vqxbrJmq3WiHh6s66ByA7oxh
         GVjo6UQnqGXbxffr/jzbn3WWR/f8WEbrKhaoGv76xK+5njxIgfwiFTkllhKNQhpPJXf2
         xlWg==
X-Gm-Message-State: AOAM5317pKxIDaUSfY31kfo9kxtHb/F5ZIm3yk6CBwr7e7JmPfmyaaZ1
        hej0s3n/ZyjTueNj4M6h0FJkqnerjbsL4jPAWLMlGRwRWxY=
X-Google-Smtp-Source: ABdhPJxDGKMeML03pyUpPJr8pqcsGWOJsjX0I+dZl4PF472qk0SNTqlA3vYYVIzK1/3bM66m8cFOA27AlHUmXXOSNnk=
X-Received: by 2002:a4a:e5d9:: with SMTP id r25mr1510956oov.90.1595983974796;
 Tue, 28 Jul 2020 17:52:54 -0700 (PDT)
MIME-Version: 1.0
From:   Ashutosh Grewal <ashutoshgrewal@gmail.com>
Date:   Tue, 28 Jul 2020 17:52:44 -0700
Message-ID: <CAKA6ep+EFNOYY8k8PFP9kf_F5GY+5g8qu_LphEAX6N7iEFTs9Q@mail.gmail.com>
Subject: Bug: ip utility fails to show routes with large # of multipath next-hops
To:     davem@davemloft.net, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David and all,

I hope this is the correct way to report a bug.

I observed this problem with 256 v4 next-hops or 128 v6 next-hops (or
128 or so # of v4 next-hops with labels).

Here is an example -

root@a6be8c892bb7:/# ip route show 2.2.2.2
Error: Buffer too small for object.
Dump terminated

Kernel details (though I recall running into the same problem on 4.4*
kernel as well) -
root@ubuntu-vm:/# uname -a
Linux ch1 5.4.0-33-generic #37-Ubuntu SMP Thu May 21 12:53:59 UTC 2020
x86_64 x86_64 x86_64 GNU/Linux

I think the problem may be to do with the size of the skbuf being
allocated as part of servicing the netlink request.

static int netlink_dump(struct sock *sk)
{
  <snip>

                skb = alloc_skb(...)

Thanks,
Ashutosh
