Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0E1506023
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 01:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbiDRXUj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 19:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbiDRXUi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 19:20:38 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63C5023BD1
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:17:57 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id hh4so3689557qtb.10
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 16:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gV7UtmajIQUducVZbRr5/Bay12YbRA1rsedm6F/j0xI=;
        b=M0q72AcD9jfg+dANbrjyHrlpiw+otlCPC3XzOhu55g0oelda3LhwCOxsI7RPsfE08t
         3qog70rS3rB1uw2/b749YJpqemXtQmY72xz+nPXSqczpIr4rs/yRwh2WfcSXUpHqxzzo
         s/HLNq4ZtgOuiSICTaKPyOUcwceY7Lt7dvYh0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gV7UtmajIQUducVZbRr5/Bay12YbRA1rsedm6F/j0xI=;
        b=nTG6mzS7EvvIXANxy7GJb2fxbWfeT/JpybBl3xTO+H9UQpzaaAr0Fc98ZwTfkOxD5Y
         1s7SOHIPhbZsaMyfNRTZvQOxU8EE8J+DEPtdvoP5AQCKgfz+PWLcuumbuCK4RFipm1VG
         wEgUjzGXEQQvsqJRiWPGkUdZCbRoMlVK0XZxWavA0W5KuuPbHio5j+JIVB/R7lAeU8wp
         RVDMQChV/Rofy4QYys+23YMiotxW/NieYgDHBfjLaP7+FLutzlhGJvutNwvcfLR8yJsP
         gi4t4JmcgEdIAvIZlSEMfJl9Y0fsoHk6y6VuHAhe/GiDqnx6l+D75+wJgZ71MOU2xk7K
         nW2A==
X-Gm-Message-State: AOAM531eCz8WMoz7pvcBFaGX244nDgHHpOUJLiLd8DMGcZXozYL0ZojD
        xh5qAzPgZv9mVsEuD0ezj6Yx0w==
X-Google-Smtp-Source: ABdhPJzH71KiFd0XgGFFJT13Z9K5HJ1+NRM6zFLxHEeOW6BBln/hR2wG3NyC9DFPKGe+vfPXcGk5lg==
X-Received: by 2002:ac8:5dca:0:b0:2f1:fcc6:d85a with SMTP id e10-20020ac85dca000000b002f1fcc6d85amr5238941qtx.72.1650323876585;
        Mon, 18 Apr 2022 16:17:56 -0700 (PDT)
Received: from grundler-glapstation.lan ([70.134.62.80])
        by smtp.gmail.com with ESMTPSA id a1-20020a05622a02c100b002f17cba4930sm8214048qtx.85.2022.04.18.16.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 16:17:55 -0700 (PDT)
From:   Grant Grundler <grundler@chromium.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Aashay Shringarpure <aashay@google.com>,
        Yi Chou <yich@google.com>,
        Shervin Oloumi <enlightened@google.com>,
        Grant Grundler <grundler@chromium.org>
Subject: [PATCH 0/5] net: atlantic: more fuzzing fixes
Date:   Mon, 18 Apr 2022 16:17:41 -0700
Message-Id: <20220418231746.2464800-1-grundler@chromium.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Chrome OS fuzzing team posted a "Fuzzing" report for atlantic driver
in Q4 2021 using Chrome OS v5.4 kernel and "Cable Matters
Thunderbolt 3 to 10 Gb Ethernet" (b0 version):
    https://docs.google.com/document/d/e/2PACX-1vT4oCGNhhy_AuUqpu6NGnW0N9HF_jxf2kS7raOpOlNRqJNiTHAtjiHRthXYSeXIRTgfeVvsEt0qK9qK/pub

It essentially describes four problems:
1) validate rxd_wb->next_desc_ptr before populating buff->next
2) "frag[0] not initialized" case in aq_ring_rx_clean()
3) limit iterations handling fragments in aq_ring_rx_clean()
4) validate hw_head_ in hw_atl_b0_hw_ring_tx_head_update()

I've added one "clean up" contribution:
    "net: atlantic: reduce scope of is_rsc_complete"

I tested the "original" patches using chromeos-v5.4 kernel branch:
    https://chromium-review.googlesource.com/q/hashtag:pcinet-atlantic-2022q1+(status:open%20OR%20status:merged)

The fuzzing team will retest using the chromeos-v5.4 patches and the b0 HW.

I've forward ported those patches to 5.18-rc2 and compiled them but am
currently unable to test them on 5.18-rc2 kernel (logistics problems).

I'm confident in all but the last patch:
   "net: atlantic: verify hw_head_ is reasonable"

Please verify I'm not confusing how ring->sw_head and ring->sw_tail
are used in hw_atl_b0_hw_ring_tx_head_update().

Credit largely goes to Chrome OS Fuzzing team members:
    Aashay Shringarpure, Yi Chou, Shervin Oloumi

cheers,
grant
