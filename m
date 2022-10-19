Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA6C96047EC
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 15:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233500AbiJSNrT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 09:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232971AbiJSNqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 09:46:07 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C27AEF5B9;
        Wed, 19 Oct 2022 06:31:59 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id z97so25267200ede.8;
        Wed, 19 Oct 2022 06:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FpZmcn2cTD/NH3e8oQBnzwHR3E7WtRpt5UObiqSdGoY=;
        b=KprqBJRE/SGTZhmUZri4mNeE9YuwwHHZCJpYeclhGOKTTjX4t/I2++rxLhxZ/Ng0Tx
         Dj4jCN4ziikaQzOS0MiqJ6+wSchWXQlBlVb0u/spRsSq0KR2UDqzXCfkf/sow2cyPHrX
         0Tsc3Pa6hs47vFDBCtwnvyRYwxByXWDVpG2IIXjLWMH3InkB3nxwJx53waPbSotJV36p
         faPSNNjD+HPf5ge0cCFEkxQlTPU9CbuchO46QorySFOx7EYQdrlzKQoxBp+Nm/WwjnTc
         HmfQ9xq6E9KtmyapGLAfaPfOtAMWG719ISIdtvK9rB0BaVSzhwzXDOY/eqPj3vAfo6jZ
         S6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FpZmcn2cTD/NH3e8oQBnzwHR3E7WtRpt5UObiqSdGoY=;
        b=YGnx8f1vRtBnFx/Bg3VBdVlt2dDJ63vwIkhgTNUc9WIRZTRTshXmZTWlf89SirDFpH
         ZPDDeB/N1YSGg5DSpMWvqLUvASk/ITO+wZjAc6fJlafCDuZ0MYKPo0Mre60UOCaP1/xn
         q0U+Uw1ZOMnka4jPAi4x1LRncT81C8hODJcz0cbcXsAU73FHP1Ev/kI+CDtar6WGaZRi
         UlMzIP2S/VKZtGu29A0DjS0sw1AY9UyQVmzx63/DmPFbSfGdfLql3B3szLopuPpAuAti
         qGbWp2fsJ9QGf1RnFkXvC/C7BtLtQ8w/97jr1ALxLQ8693jOEVmAMtgHtyJQzQGgSwcU
         CI9Q==
X-Gm-Message-State: ACrzQf2nFCW0rC66iaaf0O4JFGPc9cgvdcR2+UkZ9AWWe1rrzMfV652X
        QwM6RhvWeGWmFaRRBWD6Q4Q=
X-Google-Smtp-Source: AMsMyM7rjlStMfKaq7jnq1Q9XwOzTya1m2gh1pfsMtivYdp8gPVPN7mlHvxJ4K4WxSseZVrgogrtlg==
X-Received: by 2002:aa7:c78e:0:b0:456:c524:90ec with SMTP id n14-20020aa7c78e000000b00456c52490ecmr7488174eds.192.1666186295800;
        Wed, 19 Oct 2022 06:31:35 -0700 (PDT)
Received: from ThinkStation-P340.. (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id o14-20020a170906768e00b0077a8fa8ba55sm8894792ejm.210.2022.10.19.06.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 06:31:35 -0700 (PDT)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next 0/2] net: usb: qmi_wwan implement tx packets aggregation
Date:   Wed, 19 Oct 2022 15:25:01 +0200
Message-Id: <20221019132503.6783-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Bjørn and all,

this patchset implements and document tx qmap packets aggregation in qmi_wwan.

Low-cat Thread-x based modem are not capable of properly reaching the maximum
allowed throughput both in tx and rx during a bidirectional test if tx packets
aggregation is not enabled.

I verified this problem by using a MDM9207 Cat. 4 based modem (50Mbps/150Mbps
max throughput). What is actually happening is pictured at
https://drive.google.com/file/d/1xuAuDBfBEIM3Cdg2zHYQJ5tdk-JkfQn7/view?usp=sharing

When rx and tx flows are tested singularly there's no issue in tx and minor
issues in rx (a few spikes). When there are concurrent tx and rx flows, tx
throughput has an huge drop. rx a minor one, but still present.

The same scenario with tx aggregation enabled is pictured at
https://drive.google.com/file/d/1Kw8TVFLVgr31o841fRu4fuMX9DNZqJB5/view?usp=sharing
showing a regular graph.

This issue does not happen with high-cat modems (e.g. SDX20), or at least it
does not happen at the throughputs I'm able to test currently: maybe the same
could happen when moving close to the maximum rates supported by those modems.
Anyway, having the tx aggregation enabled should not hurt.

It is interesting to note that, for what I can understand, rmnet too does not
support tx aggregation.

I'm aware that rmnet should be the preferred way for qmap, but I think there's
still value in adding this feature to qmi_wwan qmap implementation since there
are in the field many users of that.

Moreover, having this in mainline could simplify backporting for those who are
using qmi_wwan qmap feature but are stuck with old kernel versions.

I'm also aware of the fact that sysfs files for configuration are not the
preferred way, but it would feel odd changing the way for configuring the driver
just for this feature, having it different from the previous knobs.

Thanks,
Daniele

Daniele Palmas (2):
  net: usb: qmi_wwan: implement qmap uplink tx aggregation
  Documentation: ABI: sysfs-class-net-qmi: document tx aggregation files

 Documentation/ABI/testing/sysfs-class-net-qmi |  28 ++
 drivers/net/usb/qmi_wwan.c                    | 242 +++++++++++++++++-
 2 files changed, 266 insertions(+), 4 deletions(-)

-- 
2.37.1

