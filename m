Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1081469C582
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 07:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjBTG52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 01:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBTG52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 01:57:28 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EF5EB6E
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 22:56:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676876200;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=qscstlydp5y4NcNc6D2hLqHdtz4SGhX1/5NqwRpYA0o=;
        b=QRsfVXSJobUKJ1Jo6RC3LV+++oGuzQudmobIFH6WBdmIN0e8ghS5mvQyFUoywR6+VcwfCs
        s0GB4FNxU16UWipiCkRnH1rWuFDYivsqhrvleEafV8JZbwICNgi+mt4/fm+nebg2Hjz8CF
        +0/z3Ru0HxUnYoC63igqVZQzAfJFO4g=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-77-XPfu7rPZNJOKX9XZZlV-DQ-1; Mon, 20 Feb 2023 01:56:38 -0500
X-MC-Unique: XPfu7rPZNJOKX9XZZlV-DQ-1
Received: by mail-wr1-f70.google.com with SMTP id v10-20020a056000144a00b002be0eb97f4fso129354wrx.8
        for <netdev@vger.kernel.org>; Sun, 19 Feb 2023 22:56:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:date:cc:to:from
         :subject:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qscstlydp5y4NcNc6D2hLqHdtz4SGhX1/5NqwRpYA0o=;
        b=ZCQj3urqDDtpX140daGe0l0MnzN6gsrb8X43y9erPMQezoF7MBgWnMWyu83X221Zcf
         m3MbdpyJpDVAwCSPGxInRlVd5dt+o/fs3R9boWAhtseTLhMNzxuk2asulQDk35eMaWfg
         h4wFa5wYLMUdEZHHY8aunO0Wqi0xf6SU3srs3sxV08TvUs95ABxzhTfiUmvrBD4laonw
         AgjwdMuS9FB9TDX1pPFJb0yf6fVJKF66HPVEusaD1pAVqPoxXlOl1Vb7mFOT6TO1LGAY
         3BlAXvtwMCkbbrev9ut+FsygDUAChG/gYqGA12t8iiiDuzVZg4DHdjJGirWTzVePepc6
         qXvQ==
X-Gm-Message-State: AO0yUKVMUrathSMAF0dU0BVsKS8r3EbE2hbF62rjFBkQbZK9ooj7hLhq
        XQG6MXpNPyrVGVPXnS6ENp87iD6f1hEGIqpKJWF3Yc+h+36OSiLtxusGfH2m4qHdKB/jKi/saZy
        tavxAZAPVfwAOe7wK+SEekGUUE0KuUPbhsAAT2+VgxluY6QyPXCFD5GJoaU1kuYEKIOkfkWU=
X-Received: by 2002:a05:600c:1c18:b0:3e2:dbb:5627 with SMTP id j24-20020a05600c1c1800b003e20dbb5627mr252524wms.3.1676876197117;
        Sun, 19 Feb 2023 22:56:37 -0800 (PST)
X-Google-Smtp-Source: AK7set91oE7/J1Cm9gSsHpmkvgrZMjjp/HofiOZAvYybbsih8lHAiX0anHCdtdLA0+jaRPtGS1XAVw==
X-Received: by 2002:a05:600c:1c18:b0:3e2:dbb:5627 with SMTP id j24-20020a05600c1c1800b003e20dbb5627mr252508wms.3.1676876196707;
        Sun, 19 Feb 2023 22:56:36 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-121-8.dyn.eolo.it. [146.241.121.8])
        by smtp.gmail.com with ESMTPSA id y25-20020a1c4b19000000b003dc4480df80sm9630735wma.34.2023.02.19.22.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Feb 2023 22:56:36 -0800 (PST)
Message-ID: <e3e8fe0a646fbbbd64e47623aef40ff7ae3ecc8a.camel@redhat.com>
Subject: net-next is CLOSED
From:   Paolo Abeni <pabeni@redhat.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Mon, 20 Feb 2023 07:56:34 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Linus has tagged v6.2, so please defer posting new features,
re-factoring etc. until the 6.3 merge window is over.

As usual, feel free sharing RFC for such topics even in the merge
window.

Thanks,

Paolo



