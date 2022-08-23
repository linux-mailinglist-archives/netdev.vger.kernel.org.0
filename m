Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F2759E69C
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 18:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243734AbiHWQI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 12:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243842AbiHWQIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:08:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E030AD9B9
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 05:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661257206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nch+IXHIDBrWVkXtWbywK+c3Bny+KWw7qcMu+C2LRF0=;
        b=i4QyZU1FveKWYW85hYdQaTjyEKgU3wfOJ6TLAwq1d9jHarzxhR49Bi9g/RoC81sprfTcol
        IqJZi6Y/z4ohpFQEjaavYygl7nKuq9AEkYYuLrEMVITYus0WOYfEVkEh88+ExsxMkxBEa1
        Gz1fTsc2br3Q6zY1zmvrkQ1AVtKaKwY=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-588-3ArPwFbKN7Gn-PLuHeu7Lw-1; Tue, 23 Aug 2022 06:58:05 -0400
X-MC-Unique: 3ArPwFbKN7Gn-PLuHeu7Lw-1
Received: by mail-wm1-f71.google.com with SMTP id a17-20020a05600c349100b003a545125f6eso10076192wmq.4
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:58:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc;
        bh=Nch+IXHIDBrWVkXtWbywK+c3Bny+KWw7qcMu+C2LRF0=;
        b=ejCaghumQD0aaV3gEWTQczS4XB44lw/4B15PiBPLzUvYC+WzynSawEDhUsavq6KxVi
         tuYXbtLX7wLJzpW/cQedyqxtV3ex3bNqt3TsLe4MtgAXomW2OQhdKk29mtKRTPJ/i2Yb
         o2JAob7v/AIJnkbIex5VxRzdtmiJeXNyXYjoGdweiI6xkTm5xz7wtTv0ykAs/LsCH9EO
         Nx4g/LLw6cNY1WtjBdGWOc0mt8eNsCFSyRbMKpKVX0Y3L4QJa1CMIaCzC1SLgno0l+Em
         OCSAnE5wEnqNnA11EogIEZilyRfIVDLbNKj4drT7MlaI5D41le31ZIzdm1Rd8q06lBGU
         cYvw==
X-Gm-Message-State: ACgBeo0jFGSIcqIiiIuIpFRdmwYP3FfuXACvfdQdHjYmvc5O4OQI4XHR
        l1PSF+VREGk0JTeoG+IYOgT2BmNfYtmGd9B0GlReiVZ4O1WJKSunH3o2K9yQNcrsK868yWtdUME
        IfBc1SoIxkBaOqhpV
X-Received: by 2002:a05:600c:3d91:b0:3a5:4132:b6a0 with SMTP id bi17-20020a05600c3d9100b003a54132b6a0mr1691420wmb.126.1661252284494;
        Tue, 23 Aug 2022 03:58:04 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6bDQBAoacU9DIFFDvh3Vtxv7kMelU00DA0jkotOluxkAmKaIuNvBHrTwg5CLgfPziqdhVLQA==
X-Received: by 2002:a05:600c:3d91:b0:3a5:4132:b6a0 with SMTP id bi17-20020a05600c3d9100b003a54132b6a0mr1691414wmb.126.1661252284292;
        Tue, 23 Aug 2022 03:58:04 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-176.dyn.eolo.it. [146.241.97.176])
        by smtp.gmail.com with ESMTPSA id j18-20020a05600c191200b003a5c1e916c8sm2680414wmq.1.2022.08.23.03.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Aug 2022 03:58:03 -0700 (PDT)
Message-ID: <110a99aba78eb62daa5653104e5ef4e53dc92c74.camel@redhat.com>
Subject: Re: [PATCH 1/2] net: mt7531: only do PLL once after the reset
From:   Paolo Abeni <pabeni@redhat.com>
To:     Alexander Couzens <lynxis@fe80.eu>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Tue, 23 Aug 2022 12:58:02 +0200
In-Reply-To: <20220820213707.46138-1-lynxis@fe80.eu>
References: <20220820213707.46138-1-lynxis@fe80.eu>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-08-20 at 23:37 +0200, Alexander Couzens wrote:
> Move the PLL init of the switch out of the pad configuration of the port
> 6 (usally cpu port).
> 
> Fix a unidirectional 100 mbit limitation on 1 gbit or 2.5 gbit links for
> outbound traffic on port 5 or port 6.
> 
> Signed-off-by: Alexander Couzens <lynxis@fe80.eu>

This (and the next patch) looks like a fix suitable for -net. Could you
please re-post, targeting the appropriate tree and more importantly
including a 'Fixes' tag in the commit message of each patch?

Thanks!

Paolo

