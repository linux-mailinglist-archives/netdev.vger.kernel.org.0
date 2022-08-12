Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE815913DA
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 18:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239320AbiHLQ2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 12:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238193AbiHLQ2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 12:28:20 -0400
Received: from sender-of-o50.zoho.in (sender-of-o50.zoho.in [103.117.158.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D7DFABF2C;
        Fri, 12 Aug 2022 09:28:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1660321662; cv=none; 
        d=zohomail.in; s=zohoarc; 
        b=TIgpFcuFRXdiCpes87hIIXQ1Wghp5OVWIe4nAx5WXJaOYHU9wRXjYHq3Se3qitu8+FUy+VvTryNkdXB6pXzkBDapNgLU7zvNwh13zsz+sxzsnwnzYKsXBJ2sKjbYK6L6D+PPlvkDFehWxOL0djZHrok1BQ8/CS9Lyt+8p916rDo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
        t=1660321662; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=MJyv8/T3AsC5yGTNAapmuhGn+zH2Um3nfzqkYfPuPP8=; 
        b=Lrf/qyekzRv0v+9jKCySkNuvUn1IS8CAvJSuYwlSNV7ieNCRblN+ZJuTt2izrO1H/iApvFU9hvfUl23azD0fgTbNuQOcUltGloqoA7MObnsHa2QqQ+RG5B09qQvZeQ7IMhTAt0j69vI6Gm9jBi2pKjXQhQtKI9pPa592naQC4vg=
ARC-Authentication-Results: i=1; mx.zohomail.in;
        dkim=pass  header.i=siddh.me;
        spf=pass  smtp.mailfrom=code@siddh.me;
        dmarc=pass header.from=<code@siddh.me>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1660321662;
        s=zmail; d=siddh.me; i=code@siddh.me;
        h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=MJyv8/T3AsC5yGTNAapmuhGn+zH2Um3nfzqkYfPuPP8=;
        b=eHNSW7WorTicEALoMtyy5z1MibmL3rbRlfw6YRakdsUSHN9KNBEsrQBwtZlk54dh
        +uPa8hy4gYw/wXbS6Tgy7Rcz3eGgiRYJiZuBcPov+m4YgdYxdfJ0zer8vc+zsYKFjly
        7/EBC+S49yXN3O1VKRs+Ru/ULy7EEDWsmGnFo6Y4=
Received: from mail.zoho.in by mx.zoho.in
        with SMTP id 1660321651956275.37477643119485; Fri, 12 Aug 2022 21:57:31 +0530 (IST)
Date:   Fri, 12 Aug 2022 21:57:31 +0530
From:   Siddh Raman Pant <code@siddh.me>
To:     "Greg KH" <gregkh@linuxfoundation.org>
Cc:     "johannes berg" <johannes@sipsolutions.net>,
        "david s. miller" <davem@davemloft.net>,
        "eric dumazet" <edumazet@google.com>,
        "jakub kicinski" <kuba@kernel.org>,
        "paolo abeni" <pabeni@redhat.com>,
        "netdev" <netdev@vger.kernel.org>,
        "syzbot+6cb476b7c69916a0caca" 
        <syzbot+6cb476b7c69916a0caca@syzkaller.appspotmail.com>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "syzbot+f9acff9bf08a845f225d" 
        <syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com>,
        "syzbot+9250865a55539d384347" 
        <syzbot+9250865a55539d384347@syzkaller.appspotmail.com>,
        "linux-kernel-mentees" 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Message-ID: <18292e1dcd8.2359a549180213.8185874405406307019@siddh.me>
In-Reply-To: <YvZxfpY4JUqvsOG5@kroah.com>
References: <20220726123921.29664-1-code@siddh.me>
 <18291779771.584fa6ab156295.3990923778713440655@siddh.me>
 <YvZEfnjGIpH6XjsD@kroah.com>
 <18292791718.88f48d22175003.6675210189148271554@siddh.me> <YvZxfpY4JUqvsOG5@kroah.com>
Subject: Re: [PATCH v2] wifi: cfg80211: Fix UAF in ieee80211_scan_rx()
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Aug 2022 20:57:58 +0530  Greg KH  wrote:
> rcu just delays freeing of an object, you might just be delaying the
> race condition.  Just moving a single object to be freed with rcu feels
> very odd if you don't have another reference somewhere.

As mentioned in patch message, in net/mac80211/scan.c, we have:
        void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
        {
                ...
                scan_req = rcu_dereference(local->scan_req);
                sched_scan_req = rcu_dereference(local->sched_scan_req);

                if (scan_req)
                        scan_req_flags = scan_req->flags;
                ...
        }

So scan_req is probably supposed to be protected by RCU.

Also, in ieee80211_local's definition at net/mac80211/ieee80211_i.h, we have:
        struct cfg80211_scan_request __rcu *scan_req;

Thus, scan_req is indeed supposed to be protected by RCU, which this patch
addresses by adding a RCU head to the type's struct, and using kfree_rcu().

The above snippet is where the UAF happens (you can refer to syzkaller's log),
because __cfg80211_scan_done() is called and frees the pointer.

Thanks,
Siddh

