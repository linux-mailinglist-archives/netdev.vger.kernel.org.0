Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D023C633CF4
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 13:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbiKVM4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 07:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233786AbiKVMz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 07:55:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B252161B8D
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:54:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669121695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PfHnKgkTBDMrBm8PUI8Fl6SbsIzlbvafvKcNrxienW8=;
        b=LECswkZhu0W+m9DabBAzdj01C3gI4H4xngmgLYfA5ugfpQKZszPTD2BtmjM8DhT80wNFo0
        Iy8YNQwQv8hOAOcq+D5Esp1I7ar24Tmmm+vxvV6XY2OFCpdkpztgOaFKOBwCK1h/0kO5AJ
        qb+VgUHMlAtvl7yfwg5V0xBfYLItxDw=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-620-FOKsJxVDPDSLBsPrmhaPYw-1; Tue, 22 Nov 2022 07:54:52 -0500
X-MC-Unique: FOKsJxVDPDSLBsPrmhaPYw-1
Received: by mail-qv1-f69.google.com with SMTP id b2-20020a0cfe62000000b004bbfb15297dso13956409qvv.19
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 04:54:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PfHnKgkTBDMrBm8PUI8Fl6SbsIzlbvafvKcNrxienW8=;
        b=pVe2gzl53OfL3TpjvCs8ILAf0UqND84EbnYd90Uttwti60U4jyoRO2PEMNlsIn5DXf
         iLCTY5NKDd2MTdGr/IIzb9uA7xQ7Mho+tYhpvzwTsSIHQrfPsf0VN+Pm+WSluhvqUUWo
         Xq3booWyac2ryJGTsAWkvCOk0YUsCsg8Wn9h+7M+Xxb6kEZEs5BoQMZZhftr8AnLmR1M
         bZ8sLpdoEjx1sbY+XOXklm2kG8kChd9mCu/GNXNyy2cZiJ+PZ+mYKK3dC6/IGh0D/KRg
         wDpwr91yUiC8t5kucbayazHPUE+oyt9nB5ITM2/i1piDpBRKGqmVATJYJZrWGbsTFAEK
         QRMw==
X-Gm-Message-State: ANoB5pmdakzjCAfkDSw+V/h/4WryDiqWKrCjzQyGUwOY4LJH7roUpTSW
        fmgOQAbg/Lyw8bckAJh//7pEIqCKprr0SP8W5zPqtf1eLwzm4geN1zHGgoDiIqUpD4BHsUXG9qY
        W9kro7smJQ2dk1Rx0
X-Received: by 2002:ac8:5441:0:b0:3a5:7ba9:704f with SMTP id d1-20020ac85441000000b003a57ba9704fmr21993800qtq.331.1669121692384;
        Tue, 22 Nov 2022 04:54:52 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6sB1UeXO6TfXaiROwERQDrXihHhPOOYXKOffZOZkVabz1mI2VJFjAK1bEaGqc+z6CdzyzfSQ==
X-Received: by 2002:ac8:5441:0:b0:3a5:7ba9:704f with SMTP id d1-20020ac85441000000b003a57ba9704fmr21993788qtq.331.1669121692163;
        Tue, 22 Nov 2022 04:54:52 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id z63-20020a37b042000000b006fafaac72a6sm9896291qke.84.2022.11.22.04.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 04:54:51 -0800 (PST)
Message-ID: <ee1de4c0e20d4af6b65b6c209d1e8df6b13812ab.camel@redhat.com>
Subject: Re: [PATCH net-next] selftests: net: Add cross-compilation support
 for BPF programs
From:   Paolo Abeni <pabeni@redhat.com>
To:     =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     =?ISO-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
        Lina Wang <lina.wang@mediatek.com>,
        linux-kselftest@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>
Date:   Tue, 22 Nov 2022 13:54:48 +0100
In-Reply-To: <20221119171841.2014936-1-bjorn@kernel.org>
References: <20221119171841.2014936-1-bjorn@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-11-19 at 18:18 +0100, Björn Töpel wrote:
> From: Björn Töpel <bjorn@rivosinc.com>
> 
> The selftests/net does not have proper cross-compilation support, and
> does not properly state libbpf as a dependency. Mimic/copy the BPF
> build from selftests/bpf, which has the nice side-effect that libbpf
> is built as well.
> 
> Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
> ---
> Now that BPF builds are starting to show up in more places
> (selftests/net, and soon selftests/hid), maybe it would be cleaner to
> move parts of the BPF builds to lib.mk?

+1 on such follow-up ;)

Thanks!

Paolo

