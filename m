Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 019A9599C3A
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 14:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349007AbiHSMi2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 08:38:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348748AbiHSMiW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 08:38:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9059A3887
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 05:38:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660912699;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LnnHIdU9DhmzWk8QeMkO+lqibVxsY1+S011HcqEI9i8=;
        b=H6No3tuQ+9O1SIbD1iycnOBX5Btw8wHJ1k3wKWgGkPPv2628miuPL2rxZ3iTTvVpOaPH7m
        hsoxe4PzHw5b/GfFBq6oz3kqFBFrTM5ctCAJ04pFPNRuL7rRWD9h56mCssBjGByPFAUPVF
        /7RPLH+jdQ5paueLYG0SDUANSBFo048=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-659-CVYWdGJyNWeJwyGzIaACCg-1; Fri, 19 Aug 2022 08:38:18 -0400
X-MC-Unique: CVYWdGJyNWeJwyGzIaACCg-1
Received: by mail-ed1-f70.google.com with SMTP id w17-20020a056402269100b0043da2189b71so2706508edd.6
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 05:38:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=LnnHIdU9DhmzWk8QeMkO+lqibVxsY1+S011HcqEI9i8=;
        b=B8NbFHcJu54FMS5DRdfy89cJmOkwtsf9UcfgbIPXlyDNyP7YPCbyCeExIkY8bu4AmJ
         u0wa4t/NPMrtri2o/mkY3TffkimBiuYs7aTED6H/pTl4/X9iE2yibHcxP5klY7z21ZBQ
         kTSsE4LZV0SxnY94Dx+0H+iwqoVXM8591mk+VxLJbGgT52xQez2r9lVwmSNuiJTFaDra
         F2OcbrXUln3uomDQ6IiVYACqIp/mbunJuSIZurc0fwjA19UsFpyM/jqzwgudGmvA8sTW
         4h2i17g8SN3eIiEeSctlewQ93kOz2J8SoWbw+W4v/cKDGcskTnbN3meNXx5iWlDWrUZd
         w7fQ==
X-Gm-Message-State: ACgBeo1z+USe6veveEjD7r+LXgeoMCtqhcxoRuD02DN45haDWHKuxpdI
        av9SA2dNlNCTg+sEA01gEQo+cIFoVtSPLiBHT7QP5rhD8eKkR3IDEgNfWs21lKLlJ8dvV3MDzAD
        OjbxK9pAZ+xFafQ25
X-Received: by 2002:a05:6402:2755:b0:43d:7568:c78e with SMTP id z21-20020a056402275500b0043d7568c78emr6055999edd.104.1660912696564;
        Fri, 19 Aug 2022 05:38:16 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5KeeNxqlZu+lhdGWImyOSstrSOYLHE6QBFFPEMo2WU91SqJCO2hfRq6xjWHfUJ3Cs7Wa9Tag==
X-Received: by 2002:a05:6402:2755:b0:43d:7568:c78e with SMTP id z21-20020a056402275500b0043d7568c78emr6055961edd.104.1660912695840;
        Fri, 19 Aug 2022 05:38:15 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id v6-20020a056402174600b0043cab10f702sm3022072edx.90.2022.08.19.05.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 05:38:15 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 7F83955FC0B; Fri, 19 Aug 2022 14:38:14 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf-next 1/3] dev: Move received_rps counter next to RPS
 members in softnet data
In-Reply-To: <20220818200143.7d534a41@kernel.org>
References: <20220818165906.64450-1-toke@redhat.com>
 <20220818165906.64450-2-toke@redhat.com>
 <20220818200143.7d534a41@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 19 Aug 2022 14:38:14 +0200
Message-ID: <87bksgv26h.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 18 Aug 2022 18:59:03 +0200 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Move the received_rps counter value next to the other RPS-related members
>> in softnet_data. This closes two four-byte holes in the structure, making
>> room for another pointer in the first two cache lines without bumping the
>> xmit struct to its own line.
>
> What's the pointer you're making space for (which I hope will explain
> why this patch is part of this otherwise bpf series)?

The XDP queueing series adds a pointer to keep track of which interfaces
were scheduled for transmission using the XDP dequeue hook (similar to
how the qdisc wake code works):

https://lore.kernel.org/r/20220713111430.134810-12-toke@redhat.com

Note that it's still up in the air if this ends up being the way this
will be implemented, so I'm OK with dropping this patch for now if you'd
rather wait until it's really needed. OTOH it also seemed like a benign
change on its own, so I figured I might as well include this patch when
sending these out. WDYT?

-Toke

