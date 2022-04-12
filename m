Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0B934FE6D2
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 19:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347315AbiDLRaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 13:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235665AbiDLRaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 13:30:07 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B519852B2A
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:27:47 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id s13so24978145ljd.5
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 10:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=ThAY3Ed/dk6m+iaWZn0wjwKwYvlAqcEvAvL+WRRtrb0=;
        b=VtOnhHywQSKBg+GRfttHHC8ae5LyqPtsEzJ/crFnQSt+funvR7/8PtgornBKeYebKm
         cSDCNVpdIF/s8sc7rYRvF34NyNzfqXXBenMwNmc7sAj4jZVBue5zwOzlUAXKuBURJUt3
         lSUqmpKK+p2diqCm3O7GhD45+L9W60gKgKQtGP9OCp4MMrMLjsqXgWqwRSwuoWGJ0CKv
         cNgHbrjTvri8o956YdK7UxS2I8N5NK1ZO5y9df/M8/Rx2Ha4hZ1dGTYcQ4KFJF8rgsk5
         zKvazIslIgk/T/+N2qDruNmqasEsvu5YyERumQr9NzFcTrnC5XYGJcm9ZJi1MM54FcVS
         4Kmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=ThAY3Ed/dk6m+iaWZn0wjwKwYvlAqcEvAvL+WRRtrb0=;
        b=IMFtGg0/4z1+sb0Mu9FkKFA3P0ah5Wvaolflsfz6kahbtj1MrUjFgrYkJymkahiIll
         jZbT65/IQVwxQGBfzR6RQJmrspbtL771OYKqEOSb+msBCi5tMZVo8/JdJovgwfGBKdO4
         iwO4aAwDcZA4KKMX6RJywLAQRF/QKLVbsRuZDxbY5RHgiW12mRA11tYa7ZXGeVfonsY8
         ePIjRW9NXNviUjxdUPhxZe59MbHFIUqcPPBxFu5FrsMYNrrmhRX7j6buFWmcKoRUMGM/
         spOsyFEzC+1a0+eSxAO0ONJEDqEnaWoHZzs6vk1PlNK9ETHibApEyW5JXSjE343/S3kf
         Dn4w==
X-Gm-Message-State: AOAM530Eijyh/LdIRnwe4fUvylYF4cgDmFp/8i2FOpBK4n1ZIbniY3Pk
        SwxaYPqNSt/ZTUcIOOLZWik=
X-Google-Smtp-Source: ABdhPJw/1hkLcDu4ztvmgaRue7Fo3A9Ykhtp/Im8rQj8AixV9nrhr1aAXSiK+6zVKX2+7TvfJZPyfQ==
X-Received: by 2002:a2e:9c94:0:b0:24b:3df5:64c with SMTP id x20-20020a2e9c94000000b0024b3df5064cmr17996207lji.324.1649784465750;
        Tue, 12 Apr 2022 10:27:45 -0700 (PDT)
Received: from wbg (h-158-174-22-128.NA.cust.bahnhof.se. [158.174.22.128])
        by smtp.gmail.com with ESMTPSA id p15-20020a056512312f00b0046ba5c0da2esm780443lfd.121.2022.04.12.10.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 10:27:45 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH RFC net-next 08/13] net: bridge: avoid classifying unknown multicast as mrouters_only
In-Reply-To: <ebd182a2-20bc-471c-e649-a2689ea5a5d1@blackwall.org>
References: <20220411133837.318876-1-troglobit@gmail.com> <20220411133837.318876-9-troglobit@gmail.com> <ebd182a2-20bc-471c-e649-a2689ea5a5d1@blackwall.org>
Date:   Tue, 12 Apr 2022 19:27:44 +0200
Message-ID: <87v8ve9ppr.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Nik,

and thank you for taking the time to respond!

On Tue, Apr 12, 2022 at 16:59, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> On 11/04/2022 16:38, Joachim Wiberg wrote:
>> Unknown multicast, MAC/IPv4/IPv6, should always be flooded according to
>> the per-port mcast_flood setting, as well as to detected and configured
>> mcast_router ports.

I realize I should've included a reference to RFC4541 here.  Will add
that in the non-RFC patch.

>> This patch drops the mrouters_only classifier of unknown IP multicast
>> and moves the flow handling from br_multicast_flood() to br_flood().
>> This in turn means br_flood() must know about multicast router ports.
> If you'd like to flood unknown mcast traffic when a router is present please add
> a new option which defaults to the current state (disabled).

I don't think we have to add another option, because according to the
snooping RFC[1], section 2.1.2 Data Forwarding Rules:

 "3) [..] If a switch receives an unregistered packet, it must forward
  that packet on all ports to which an IGMP[2] router is attached.  A
  switch may default to forwarding unregistered packets on all ports.
  Switches that do not forward unregistered packets to all ports must
  include a configuration option to force the flooding of unregistered
  packets on specified ports. [..]"

From this I'd like to argue that our current behavior in the bridge is
wrong.  To me it's clear that, since we have a confiugration option, we
should forward unknown IP multicast to all MCAST_FLOOD ports (as well as
the router ports).

Also, and more critically, the current behavior of offloaded switches do
forwarding like this already.  So there is a discrepancy currently
between how the bridge forwards unknown multicast and how any underlying
switchcore does it.

Sure, we'll break bridge behavior slightly by forwarding to more ports
than previous (until the group becomes known/registered), but we'd be
standards compliant, and the behavior can still be controlled per-port.

[1]: https://www.rfc-editor.org/rfc/rfc4541.html#section-2.1.2
[2]: Section 3 goes on to explain how this is similar also for MLD

>> diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
>> index 02bb620d3b8d..ab5b97a8c12e 100644
>> --- a/net/bridge/br_forward.c
>> +++ b/net/bridge/br_forward.c
>> @@ -199,9 +199,15 @@ static struct net_bridge_port *maybe_deliver(
>>  void br_flood(struct net_bridge *br, struct sk_buff *skb,
>>  	      enum br_pkt_type pkt_type, bool local_rcv, bool local_orig)
>>  {
>> +	struct net_bridge_mcast *brmctx = &br->multicast_ctx;
> Note this breaks per-vlan mcast. You have to use the inferred mctx.

Thank you, this was one of the things I was really unsure about since
the introduction of per-VLAN support.  I'll extend the prototype and
include the brmctx from br_handle_frame_finish().  Thanks!

Best regards
 /Joachim
