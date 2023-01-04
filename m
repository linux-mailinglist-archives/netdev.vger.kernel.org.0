Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B872965CB9C
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 02:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233601AbjADBm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 20:42:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238499AbjADBV7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 20:21:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA911183F;
        Tue,  3 Jan 2023 17:21:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42F36B810FA;
        Wed,  4 Jan 2023 01:21:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0516CC433EF;
        Wed,  4 Jan 2023 01:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672795314;
        bh=4jvBnvJNc2zXSp5yDCLu6zSZSHzp7k6AICwL7KNa7I4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eRkv/TIC9c3lDFQEJn3S3cK+Fm5HrBjAvoqP88qHiy+9hMFCo1EMrkZ+iYOOrRy6q
         sS3z89kuXZ+Fh/dYrE5rZbm6+iGwqKOWLgyJ1/DEGfbbtxuGKL+Fsbtnrlr4gD9hhn
         /1K2i8Qtmi95yOs0DbQB4KRJaEugKspD5QaIqz/jGqgCFwrwE+4ZtYAgMD2gu1aPL7
         h16WRIz9DhEpKHpPaOXl5v5rH1z9ozEs/EHmVTOEcNPF31FS0jkYgSj6e0ap5bHZOk
         R40Lur5+aIkTOzZZwIAsDHZruYWZAqapOqhWcr6kH41I5CLD/DVRVZW+QTr6mtTZqY
         UwnlYDPmafANA==
Date:   Tue, 3 Jan 2023 17:21:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Tariq Toukan <ttoukan.linux@gmail.com>,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, lorenzo.bianconi@redhat.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andy Gospodarek <gospo@broadcom.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, gal@nvidia.com,
        Saeed Mahameed <saeedm@nvidia.com>, tariqt@nvidia.com
Subject: Re: [PATCH net-next v2] samples/bpf: fixup some tools to be able to
 support xdp multibuffer
Message-ID: <20230103172153.58f231ba@kernel.org>
In-Reply-To: <87k0234pd6.fsf@toke.dk>
References: <20220621175402.35327-1-gospo@broadcom.com>
        <40fd78fc-2bb1-8eed-0b64-55cb3db71664@gmail.com>
        <87k0234pd6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 03 Jan 2023 16:19:49 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Hmm, good question! I don't think we've ever explicitly documented any
> assumptions one way or the other. My own mental model has certainly
> always assumed the first frag would continue to be the same size as in
> non-multi-buf packets.

Interesting! :) My mental model was closer to GRO by frags=20
so the linear part would have no data, just headers.

A random datapoint is that bpf_xdp_adjust_head() seems=20
to enforce that there is at least ETH_HLEN.
