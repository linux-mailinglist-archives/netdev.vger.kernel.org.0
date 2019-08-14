Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6ED68D78F
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfHNQBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:01:52 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43241 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfHNQBw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:01:52 -0400
Received: by mail-lf1-f66.google.com with SMTP id c19so79733027lfm.10
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 09:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4wY0puZ76rUC3DSckf3mPRYmF7SPUJuOAo8CaB7ZdL0=;
        b=ek6qJHh8grpDMf9DPB7XyzKQm9N39M5jVmFc2DDmCOdXTzqoHVHoDqoDk1YCR2lIOn
         oAbO+mrAMtobesvvsCq+HgShDk7X2zlvDeGqfsqa/NjjwWGs33Qrni2SlvGQSGrbholN
         0HekEIdqh5fmessXGirxHkOVY6vFbk6n+jk3o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4wY0puZ76rUC3DSckf3mPRYmF7SPUJuOAo8CaB7ZdL0=;
        b=HonSXLGkPRbhA31LBFExvCJTjMj71Dxbrxdstm5CR28NBBlyRr6a+R2qqchbvHzKC1
         vR3M7JH3wpN9gwsuacBH4FwLZVCWH59nIXRJNC79FHWEmse8T4zxcA8dwoz4T2TKARED
         SvRtcyrbAHMGQzIzuiWrOmbuGNj9XrOnI8blNSH59K1m5YbfeB7dF7augZNzzd4r75yG
         CJoVVRT670hDs473qu198yjExX194nMJC7esCaC/s2igccGUxo+n6bTFNvC/1btw9wYa
         wh3O2HZbaMrY3YsWqu1wvTks8jjTkiZYeHkSY1tw83SxghFIG5NBGus7TE9UoWId2D8V
         OKCw==
X-Gm-Message-State: APjAAAUoeuzloZKVNxgpZd7soVS4+iI/TY5a4gwPO4wRFkttwsvX2mnO
        vqCLbMLpFurx9UpBwDwbeJsHDA==
X-Google-Smtp-Source: APXvYqyv81KLI7ZWHf2QoqI2EfwO+kAHqEMEoi7E++qLvVKglA5H9Nc2crBymRrmxmBPyCCMzJsP0A==
X-Received: by 2002:ac2:5104:: with SMTP id q4mr98702lfb.56.1565798509937;
        Wed, 14 Aug 2019 09:01:49 -0700 (PDT)
Received: from [192.168.0.104] ([79.134.174.40])
        by smtp.googlemail.com with ESMTPSA id d3sm3205lfj.15.2019.08.14.09.01.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Aug 2019 09:01:49 -0700 (PDT)
Subject: Re: [PATCH net-next 0/4] net: bridge: mdb: allow dump/add/del of
 host-joined entries
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, roopa@cumulusnetworks.com,
        bridge@lists.linux-foundation.org
References: <20190814144024.9710-1-nikolay@cumulusnetworks.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <81258876-5f03-002c-5aa8-2d6d00e6d99e@cumulusnetworks.com>
Date:   Wed, 14 Aug 2019 19:01:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190814144024.9710-1-nikolay@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/14/19 5:40 PM, Nikolay Aleksandrov wrote:
> Hi,
> This set makes the bridge dump host-joined mdb entries, they should be
> treated as normal entries since they take a slot and are aging out.
> We already have notifications for them but we couldn't dump them until
> now so they remained hidden. We dump them similar to how they're
> notified, in order to keep user-space compatibility with the dumped
> objects (e.g. iproute2 dumps mdbs in a format which can be fed into
> add/del commands) we allow host-joined groups also to be added/deleted via
> mdb commands. That can later be used for L2 mcast MAC manipulation as
> was recently discussed. Note that iproute2 changes are not necessary,
> this set will work with the current user-space mdb code.
> 
> Patch 01 - a trivial comment move
> Patch 02 - factors out the mdb filling code so it can be
>            re-used for the host-joined entries
> Patch 03 - dumps host-joined entries
> Patch 04 - allows manipulation of host-joined entries via standard mdb
>            calls
> 
> Thanks,
>  Nik
> 
> Nikolay Aleksandrov (4):
>   net: bridge: mdb: move vlan comments
>   net: bridge: mdb: factor out mdb filling
>   net: bridge: mdb: dump host-joined entries as well
>   net: bridge: mdb: allow add/delete for host-joined groups
> 
>  net/bridge/br_mdb.c       | 171 +++++++++++++++++++++++++-------------
>  net/bridge/br_multicast.c |  24 ++++--
>  net/bridge/br_private.h   |   2 +
>  3 files changed, 133 insertions(+), 64 deletions(-)
> 

Self-NAK
There's a double notification sent for manual add/del of host groups.
It's a trivial fix, I'll spin v2 later after running more tests.

