Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F745630B25
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 04:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbiKSDYF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 22:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiKSDX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 22:23:58 -0500
X-Greylist: delayed 4166 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 18 Nov 2022 19:23:54 PST
Received: from algol.kleine-koenig.org (algol.kleine-koenig.org [IPv6:2a01:4f8:c010:8611::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A046197EF0;
        Fri, 18 Nov 2022 19:23:53 -0800 (PST)
Received: by algol.kleine-koenig.org (Postfix, from userid 1000)
        id EF95668F728; Fri, 18 Nov 2022 23:46:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kleine-koenig.org;
        s=2022; t=1668811560;
        bh=NDSwtmqAv981uP25WaGCbnBjSGEYl4jt4slX06a5R2c=;
        h=From:To:Cc:Subject:Date:From;
        b=ECY+ek8lJAnWuhIQ2omlIizBb/a3OxB+HtgiV0pZgSWmSse7pSveqSAtGtQJsk6Iq
         oNUsI/QfAkFOgMQALmINIYm5MMKscIoYnf6ZSzh9kf5JRaE+pf6zWMwM+VmC7kveh0
         FKQolfTCY+BEPqLqXxSYRfIyNK3dmtmSyNzLET3nFyCwHBws9NejpMlsAzaKOsOuu0
         tQpj8iqpYxYKHblC1SEmLPYbPR0+j+aEPwZlfG8fNaP3dmpzfWFJPLENA3ymU4PUrD
         ST1+7BFYxg07eVwIRgg/QauHc6QFyU0xMS2KobQTGBR88suL4vi+TK9SlbWEpzCxvd
         HGbC2XLjuCMEw==
From:   =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <uwe@kleine-koenig.org>
To:     Angel Iglesias <ang.iglesiasg@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Wolfram Sang <wsa@kernel.org>
Cc:     linux-i2c@vger.kernel.org, kernel@pengutronix.de,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-gpio@vger.kernel.org,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>,
        linux-rpi-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-leds@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-media@vger.kernel.org, patches@opensource.cirrus.com,
        linux-actions@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org,
        linux-amlogic@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-mtd@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, chrome-platform@lists.linux.dev,
        linux-pm@vger.kernel.org, Purism Kernel Team <kernel@puri.sm>,
        linux-pwm@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-watchdog@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH 000/606] i2c: Complete conversion to i2c_probe_new
Date:   Fri, 18 Nov 2022 23:35:34 +0100
Message-Id: <20221118224540.619276-1-uwe@kleine-koenig.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

since commit b8a1a4cd5a98 ("i2c: Provide a temporary .probe_new()
call-back type") from 2016 there is a "temporary" alternative probe
callback for i2c drivers.

This series completes all drivers to this new callback (unless I missed
something). It's based on current next/master.
A part of the patches depend on commit 662233731d66 ("i2c: core:
Introduce i2c_client_get_device_id helper function"), there is a branch that
you can pull into your tree to get it:

	https://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux.git i2c/client_device_id_helper-immutable

I don't think it's feasable to apply this series in one go, so I ask the
maintainers of the changed files to apply via their tree. I guess it
will take a few kernel release iterations until all patch are in, but I
think a single tree creates too much conflicts.

The last patch changes i2c_driver::probe, all non-converted drivers will
fail to compile then. So I hope the build bots will tell me about any
driver I missed to convert. This patch is obviously not for application
now.

I dropped most individuals from the recipents of this mail to not
challenge the mail servers and mailing list filters too much. Sorry if
you had extra efforts to find this mail.

Best regards
Uwe

Uwe Kleine-König (606):
  tpm: st33zp24: Convert to Convert to i2c's .probe_new()
  tpm: tpm_i2c_atmel: Convert to i2c's .probe_new()
  tpm: tpm_i2c_infineon: Convert to i2c's .probe_new()
  tpm: tpm_i2c_nuvoton: Convert to i2c's .probe_new()
  tpm: tis_i2c: Convert to i2c's .probe_new()
  crypto: atmel-ecc - Convert to i2c's .probe_new()
  crypto: atmel-sha204a - Convert to i2c's .probe_new()
  extcon: fsa9480: Convert to i2c's .probe_new()
  extcon: rt8973: Convert to i2c's .probe_new()
  extcon: usbc-tusb320: Convert to i2c's .probe_new()
  gpio: max732x: Convert to i2c's .probe_new()
  gpio: pca953x: Convert to i2c's .probe_new()
  gpio: pcf857x: Convert to i2c's .probe_new()
  drm/bridge: adv7511: Convert to i2c's .probe_new()
  drm/bridge/analogix/anx6345: Convert to i2c's .probe_new()
  drm/bridge/analogix/anx78xx: Convert to i2c's .probe_new()
  drm/bridge: anx7625: Convert to i2c's .probe_new()
  drm/bridge: icn6211: Convert to i2c's .probe_new()
  drm/bridge: chrontel-ch7033: Convert to i2c's .probe_new()
  drm/bridge: it6505: Convert to i2c's .probe_new()
  drm/bridge: it66121: Convert to i2c's .probe_new()
  drm/bridge: lt8912b: Convert to i2c's .probe_new()
  drm/bridge: lt9211: Convert to i2c's .probe_new()
  drm/bridge: lt9611: Convert to i2c's .probe_new()
  drm/bridge: lt9611uxc: Convert to i2c's .probe_new()
  drm/bridge: megachips: Convert to i2c's .probe_new()
  drm/bridge: nxp-ptn3460: Convert to i2c's .probe_new()
  drm/bridge: parade-ps8622: Convert to i2c's .probe_new()
  drm/bridge: sii902x: Convert to i2c's .probe_new()
  drm/bridge: sii9234: Convert to i2c's .probe_new()
  drm/bridge: sii8620: Convert to i2c's .probe_new()
  drm/bridge: tc358767: Convert to i2c's .probe_new()
  drm/bridge: tc358768: Convert to i2c's .probe_new()
  drm/bridge/tc358775: Convert to i2c's .probe_new()
  drm/bridge: ti-sn65dsi83: Convert to i2c's .probe_new()
  drm/bridge: ti-sn65dsi86: Convert to i2c's .probe_new()
  drm/bridge: tfp410: Convert to i2c's .probe_new()
  drm/i2c/ch7006: Convert to i2c's .probe_new()
  drm/i2c/sil164: Convert to i2c's .probe_new()
  drm/i2c/tda9950: Convert to i2c's .probe_new()
  drm/i2c/tda998x: Convert to i2c's .probe_new()
  drm/panel: olimex-lcd-olinuxino: Convert to i2c's .probe_new()
  drm/panel: raspberrypi-touchscreen: Convert to i2c's .probe_new()
  i2c: core: Convert to i2c's .probe_new()
  i2c: slave-eeprom: Convert to i2c's .probe_new()
  i2c: smbus: Convert to i2c's .probe_new()
  i2c: mux: pca9541: Convert to i2c's .probe_new()
  i2c: mux: pca954x: Convert to i2c's .probe_new()
  iio: accel: adxl372_i2c: Convert to i2c's .probe_new()
  iio: accel: bma180: Convert to i2c's .probe_new()
  iio: accel: bma400: Convert to i2c's .probe_new()
  iio: accel: bmc150: Convert to i2c's .probe_new()
  iio: accel: da280: Convert to i2c's .probe_new()
  iio: accel: kxcjk-1013: Convert to i2c's .probe_new()
  iio: accel: mma7455_i2c: Convert to i2c's .probe_new()
  iio: accel: mma8452: Convert to i2c's .probe_new()
  iio: accel: mma9551: Convert to i2c's .probe_new()
  iio: accel: mma9553: Convert to i2c's .probe_new()
  iio: adc: ad7091r5: Convert to i2c's .probe_new()
  iio: adc: ad7291: Convert to i2c's .probe_new()
  iio: adc: ad799x: Convert to i2c's .probe_new()
  iio: adc: ina2xx-adc: Convert to i2c's .probe_new()
  iio: adc: ltc2471: Convert to i2c's .probe_new()
  iio: adc: ltc2485: Convert to i2c's .probe_new()
  iio: adc: ltc2497: Convert to i2c's .probe_new()
  iio: adc: max1363: Convert to i2c's .probe_new()
  iio: adc: max9611: Convert to i2c's .probe_new()
  iio: adc: mcp3422: Convert to i2c's .probe_new()
  iio: adc: ti-adc081c: Convert to i2c's .probe_new()
  iio: adc: ti-ads1015: Convert to i2c's .probe_new()
  iio: cdc: ad7150: Convert to i2c's .probe_new()
  iio: cdc: ad7746: Convert to i2c's .probe_new()
  iio: chemical: ams-iaq-core: Convert to i2c's .probe_new()
  iio: chemical: atlas-ezo-sensor: Convert to i2c's .probe_new()
  iio: chemical: atlas-sensor: Convert to i2c's .probe_new()
  iio: chemical: bme680_i2c: Convert to i2c's .probe_new()
  iio: chemical: ccs811: Convert to i2c's .probe_new()
  iio: chemical: scd4x: Convert to i2c's .probe_new()
  iio: chemical: sgp30: Convert to i2c's .probe_new()
  iio: chemical: sgp40: Convert to i2c's .probe_new()
  iio: chemical: vz89x: Convert to i2c's .probe_new()
  iio: dac: ad5064: Convert to i2c's .probe_new()
  iio: dac: ad5380: Convert to i2c's .probe_new()
  iio: dac: ad5446: Convert to i2c's .probe_new()
  iio: dac: ad5593r: Convert to i2c's .probe_new()
  iio: dac: ad5696-i2c: Convert to i2c's .probe_new()
  iio: dac: ds4424: Convert to i2c's .probe_new()
  iio: dac: m62332: Convert to i2c's .probe_new()
  iio: dac: max517: Convert to i2c's .probe_new()
  iio: dac: max5821: Convert to i2c's .probe_new()
  iio: dac: mcp4725: Convert to i2c's .probe_new()
  iio: dac: ti-dac5571: Convert to i2c's .probe_new()
  iio: gyro: bmg160_i2c: Convert to i2c's .probe_new()
  iio: gyro: itg3200_core: Convert to i2c's .probe_new()
  iio: gyro: mpu3050-i2c: Convert to i2c's .probe_new()
  iio: gyro: st_gyro_i2c: Convert to i2c's .probe_new()
  iio: health: afe4404: Convert to i2c's .probe_new()
  iio: health: max30100: Convert to i2c's .probe_new()
  iio: health: max30102: Convert to i2c's .probe_new()
  iio: humidity: am2315: Convert to i2c's .probe_new()
  iio: humidity: hdc100x: Convert to i2c's .probe_new()
  iio: humidity: hdc2010: Convert to i2c's .probe_new()
  iio: humidity: hts221_i2c: Convert to i2c's .probe_new()
  iio: humidity: htu21: Convert to i2c's .probe_new()
  iio: humidity: si7005: Convert to i2c's .probe_new()
  iio: humidity: si7020: Convert to i2c's .probe_new()
  iio: imu: bmi160/bmi160_i2c: Convert to i2c's .probe_new()
  iio: imu: fxos8700_i2c: Convert to i2c's .probe_new()
  iio: imu: inv_mpu6050: Convert to i2c's .probe_new()
  iio: imu: kmx61: Convert to i2c's .probe_new()
  iio: imu: st_lsm6dsx: Convert to i2c's .probe_new()
  iio: light: adjd_s311: Convert to i2c's .probe_new()
  iio: light: adux1020: Convert to i2c's .probe_new()
  iio: light: al3010: Convert to i2c's .probe_new()
  iio: light: al3320a: Convert to i2c's .probe_new()
  iio: light: apds9300: Convert to i2c's .probe_new()
  iio: light: apds9960: Convert to i2c's .probe_new()
  iio: light: bh1750: Convert to i2c's .probe_new()
  iio: light: bh1780: Convert to i2c's .probe_new()
  iio: light: cm3232: Convert to i2c's .probe_new()
  iio: light: cm3323: Convert to i2c's .probe_new()
  iio: light: cm36651: Convert to i2c's .probe_new()
  iio: light: gp2ap002: Convert to i2c's .probe_new()
  iio: light: gp2ap020a00f: Convert to i2c's .probe_new()
  iio: light: isl29018: Convert to i2c's .probe_new()
  iio: light: isl29028: Convert to i2c's .probe_new()
  iio: light: isl29125: Convert to i2c's .probe_new()
  iio: light: jsa1212: Convert to i2c's .probe_new()
  iio: light: ltr501: Convert to i2c's .probe_new()
  iio: light: lv0104cs: Convert to i2c's .probe_new()
  iio: light: max44000: Convert to i2c's .probe_new()
  iio: light: max44009: Convert to i2c's .probe_new()
  iio: light: noa1305: Convert to i2c's .probe_new()
  iio: light: opt3001: Convert to i2c's .probe_new()
  iio: light: pa12203001: Convert to i2c's .probe_new()
  iio: light: rpr0521: Convert to i2c's .probe_new()
  iio: light: si1133: Convert to i2c's .probe_new()
  iio: light: si1145: Convert to i2c's .probe_new()
  iio: light: st_uvis25_i2c: Convert to i2c's .probe_new()
  iio: light: stk3310: Convert to i2c's .probe_new()
  iio: light: tcs3414: Convert to i2c's .probe_new()
  iio: light: tcs3472: Convert to i2c's .probe_new()
  iio: light: tsl2563: Convert to i2c's .probe_new()
  iio: light: tsl2583: Convert to i2c's .probe_new()
  iio: light: tsl2772: Convert to i2c's .probe_new()
  iio: light: tsl4531: Convert to i2c's .probe_new()
  iio: light: us5182d: Convert to i2c's .probe_new()
  iio: light: vcnl4000: Convert to i2c's .probe_new()
  iio: light: vcnl4035: Convert to i2c's .probe_new()
  iio: light: veml6030: Convert to i2c's .probe_new()
  iio: light: veml6070: Convert to i2c's .probe_new()
  iio: light: zopt2201: Convert to i2c's .probe_new()
  iio: magnetometer: ak8974: Convert to i2c's .probe_new()
  iio: magnetometer: ak8975: Convert to i2c's .probe_new()
  iio: magnetometer: bmc150_magn_i2c: Convert to i2c's .probe_new()
  iio: magnetometer: hmc5843: Convert to i2c's .probe_new()
  iio: magnetometer: mag3110: Convert to i2c's .probe_new()
  iio: magnetometer: mmc35240: Convert to i2c's .probe_new()
  iio: magnetometer: yamaha-yas530: Convert to i2c's .probe_new()
  iio: potentiometer: ad5272: Convert to i2c's .probe_new()
  iio: potentiometer: ds1803: Convert to i2c's .probe_new()
  iio: potentiometer: max5432: Convert to i2c's .probe_new()
  iio: potentiometer: tpl0102: Convert to i2c's .probe_new()
  iio: potentiostat: lmp91000: Convert to i2c's .probe_new()
  iio: pressure: abp060mg: Convert to i2c's .probe_new()
  iio: pressure: bmp280-i2c: Convert to i2c's .probe_new()
  iio: pressure: dlhl60d: Convert to i2c's .probe_new()
  iio: pressure: dps310: Convert to i2c's .probe_new()
  iio: pressure: hp03: Convert to i2c's .probe_new()
  iio: pressure: hp206c: Convert to i2c's .probe_new()
  iio: pressure: icp10100: Convert to i2c's .probe_new()
  iio: pressure: mpl115_i2c: Convert to i2c's .probe_new()
  iio: pressure: mpl3115: Convert to i2c's .probe_new()
  iio: pressure: ms5611_i2c: Convert to i2c's .probe_new()
  iio: pressure: ms5637: Convert to i2c's .probe_new()
  iio: pressure: st_pressure_i2c: Convert to i2c's .probe_new()
  iio: pressure: t5403: Convert to i2c's .probe_new()
  iio: pressure: zpa2326_i2c: Convert to i2c's .probe_new()
  iio: proximity: isl29501: Convert to i2c's .probe_new()
  iio: proximity: mb1232: Convert to i2c's .probe_new()
  iio: proximity: pulsedlight-lidar-lite-v2: Convert to i2c's
    .probe_new()
  iio: proximity: rfd77402: Convert to i2c's .probe_new()
  iio: proximity: srf08: Convert to i2c's .probe_new()
  iio: proximity: sx9500: Convert to i2c's .probe_new()
  iio: temperature: mlx90614: Convert to i2c's .probe_new()
  iio: temperature: mlx90632: Convert to i2c's .probe_new()
  iio: temperature: tmp006: Convert to i2c's .probe_new()
  iio: temperature: tmp007: Convert to i2c's .probe_new()
  iio: temperature: tsys01: Convert to i2c's .probe_new()
  iio: temperature: tsys02d: Convert to i2c's .probe_new()
  Input: as5011 - Convert to i2c's .probe_new()
  Input: adp5588-keys - Convert to i2c's .probe_new()
  Input: adp5589-keys - Convert to i2c's .probe_new()
  Input: cap11xx - Convert to i2c's .probe_new()
  Input: dlink-dir685-touchkeys - Convert to i2c's .probe_new()
  Input: lm8323 - Convert to i2c's .probe_new()
  Input: lm8333 - Convert to i2c's .probe_new()
  Input: max7359_keypad - Convert to i2c's .probe_new()
  Input: mcs_touchkey - Convert to i2c's .probe_new()
  Input: mpr121_touchkey - Convert to i2c's .probe_new()
  Input: qt1070 - Convert to i2c's .probe_new()
  Input: qt2160 - Convert to i2c's .probe_new()
  Input: tca6416-keypad - Convert to i2c's .probe_new()
  Input: tca8418_keypad - Convert to i2c's .probe_new()
  Input: tm2-touchkey - Convert to i2c's .probe_new()
  Input: ad714x-i2c - Convert to i2c's .probe_new()
  Input: adxl34x-i2c - Convert to i2c's .probe_new()
  Input: apanel - Convert to i2c's .probe_new()
  Input: atmel_captouch - Convert to i2c's .probe_new()
  Input: bma150 - Convert to i2c's .probe_new()
  Input: cma3000_d0x_i2c - Convert to i2c's .probe_new()
  Input: da7280 - Convert to i2c's .probe_new()
  Input: drv260x - Convert to i2c's .probe_new()
  Input: drv2665 - Convert to i2c's .probe_new()
  Input: drv2667 - Convert to i2c's .probe_new()
  Input: ibm-panel - Convert to i2c's .probe_new()
  Input: kxtj9 - Convert to i2c's .probe_new()
  Input: mma8450 - Convert to i2c's .probe_new()
  Input: pcf8574_keypad - Convert to i2c's .probe_new()
  Input: cyapa - Convert to i2c's .probe_new()
  Input: elan_i2c_core - Convert to i2c's .probe_new()
  Input: synaptics_i2c - Convert to i2c's .probe_new()
  Input: rmi_i2c - Convert to i2c's .probe_new()
  Input: rmi_smbus - Convert to i2c's .probe_new()
  Input: ad7879-i2c - Convert to i2c's .probe_new()
  Input: ar1021_i2c - Convert to i2c's .probe_new()
  Input: atmel_mxt_ts - Convert to i2c's .probe_new()
  Input: auo-pixcir-ts - Convert to i2c's .probe_new()
  Input: bu21013_ts - Convert to i2c's .probe_new()
  Input: bu21029_ts - Convert to i2c's .probe_new()
  Input: chipone_icn8318 - Convert to i2c's .probe_new()
  Input: cy8ctma140 - Convert to i2c's .probe_new()
  Input: cy8ctmg110_ts - Convert to i2c's .probe_new()
  Input: cyttsp4 - Convert to i2c's .probe_new()
  Input: cyttsp5: Convert to i2c's .probe_new()
  Input: cyttsp_i2c - Convert to i2c's .probe_new()
  Input: edt-ft5x06 - Convert to i2c's .probe_new()
  Input: eeti_ts - Convert to i2c's .probe_new()
  Input: egalax_ts - Convert to i2c's .probe_new()
  Input: ektf2127 - Convert to i2c's .probe_new()
  Input: goodix - Convert to i2c's .probe_new()
  Input: hideep - Convert to i2c's .probe_new()
  Input: hx83112b: Convert to i2c's .probe_new()
  Input: hycon-hy46xx - Convert to i2c's .probe_new()
  Input: ili210x - Convert to i2c's .probe_new()
  Input: ilitek_ts_i2c - Convert to i2c's .probe_new()
  Input: iqs5xx - Convert to i2c's .probe_new()
  Input: max11801_ts - Convert to i2c's .probe_new()
  Input: mcs5000_ts - Convert to i2c's .probe_new()
  Input: melfas_mip4 - Convert to i2c's .probe_new()
  Input: migor_ts - Convert to i2c's .probe_new()
  Input: mms114 - Convert to i2c's .probe_new()
  Input: pixcir_i2c_ts - Convert to i2c's .probe_new()
  Input: raydium_i2c_ts - Convert to i2c's .probe_new()
  Input: rohm_bu21023 - Convert to i2c's .probe_new()
  Input: s6sy761 - Convert to i2c's .probe_new()
  Input: silead - Convert to i2c's .probe_new()
  Input: sis_i2c - Convert to i2c's .probe_new()
  Input: st1232 - Convert to i2c's .probe_new()
  Input: stmfts - Convert to i2c's .probe_new()
  Input: sx8654 - Convert to i2c's .probe_new()
  Input: tsc2004 - Convert to i2c's .probe_new()
  Input: tsc2007_core - Convert to i2c's .probe_new()
  Input: wacom_i2c - Convert to i2c's .probe_new()
  Input: wdt87xx_i2c - Convert to i2c's .probe_new()
  Input: zet6223 - Convert to i2c's .probe_new()
  Input: zforce_ts - Convert to i2c's .probe_new()
  leds: bd2802: Convert to i2c's .probe_new()
  leds: blinkm: Convert to i2c's .probe_new()
  leds: is31fl32xx: Convert to i2c's .probe_new()
  leds: lm3530: Convert to i2c's .probe_new()
  leds: lm3532: Convert to i2c's .probe_new()
  leds: lm355x: Convert to i2c's .probe_new()
  leds: lm3642: Convert to i2c's .probe_new()
  leds: lm3692x: Convert to i2c's .probe_new()
  leds: lm3697: Convert to i2c's .probe_new()
  leds: lp3944: Convert to i2c's .probe_new()
  leds: lp3952: Convert to i2c's .probe_new()
  leds: lp5521: Convert to i2c's .probe_new()
  leds: lp5523: Convert to i2c's .probe_new()
  leds: lp5562: Convert to i2c's .probe_new()
  leds: lp8501: Convert to i2c's .probe_new()
  leds: lp8860: Convert to i2c's .probe_new()
  leds: pca9532: Convert to i2c's .probe_new()
  leds: pca963x: Convert to i2c's .probe_new()
  leds: tca6507: Convert to i2c's .probe_new()
  leds: tlc591xx: Convert to i2c's .probe_new()
  leds: turris-omnia: Convert to i2c's .probe_new()
  macintosh: ams/ams-i2c: Convert to i2c's .probe_new()
  macintosh: therm_adt746x: Convert to i2c's .probe_new()
  macintosh: therm_windtunnel: Convert to i2c's .probe_new()
  macintosh: windfarm_ad7417_sensor: Convert to i2c's .probe_new()
  macintosh: windfarm_fcu_controls: Convert to i2c's .probe_new()
  macintosh: windfarm_lm75_sensor: Convert to i2c's .probe_new()
  macintosh: windfarm_lm87_sensor: Convert to i2c's .probe_new()
  macintosh: windfarm_max6690_sensor: Convert to i2c's .probe_new()
  macintosh: windfarm_smu_sat: Convert to i2c's .probe_new()
  media: dvb-frontends/a8293: Convert to i2c's .probe_new()
  media: dvb-frontends/af9013: Convert to i2c's .probe_new()
  media: dvb-frontends/af9033: Convert to i2c's .probe_new()
  media: dvb-frontends/au8522_decoder: Convert to i2c's .probe_new()
  media: dvb-frontends/cxd2099: Convert to i2c's .probe_new()
  media: dvb-frontends/cxd2820r_core: Convert to i2c's .probe_new()
  media: dvb-frontends/dvb-pll: Convert to i2c's .probe_new()
  media: dvb-frontends/helene: Convert to i2c's .probe_new()
  media: dvb-frontends/lgdt3306a: Convert to i2c's .probe_new()
  media: dvb-frontends/lgdt330x: Convert to i2c's .probe_new()
  media: dvb-frontends/m88ds3103: Convert to i2c's .probe_new()
  media: dvb-frontends/mn88443x: Convert to i2c's .probe_new()
  media: dvb-frontends/mn88472: Convert to i2c's .probe_new()
  media: dvb-frontends/mn88473: Convert to i2c's .probe_new()
  media: dvb-frontends/mxl692: Convert to i2c's .probe_new()
  media: dvb-frontends/rtl2830: Convert to i2c's .probe_new()
  media: dvb-frontends/rtl2832: Convert to i2c's .probe_new()
  media: dvb-frontends/si2165: Convert to i2c's .probe_new()
  media: dvb-frontends/si2168: Convert to i2c's .probe_new()
  media: dvb-frontends/sp2: Convert to i2c's .probe_new()
  media: dvb-frontends/stv090x: Convert to i2c's .probe_new()
  media: dvb-frontends/stv6110x: Convert to i2c's .probe_new()
  media: dvb-frontends/tc90522: Convert to i2c's .probe_new()
  media: dvb-frontends/tda10071: Convert to i2c's .probe_new()
  media: dvb-frontends/ts2020: Convert to i2c's .probe_new()
  media: i2c/ad5820: Convert to i2c's .probe_new()
  media: i2c/ad9389b: Convert to i2c's .probe_new()
  media: i2c/adp1653: Convert to i2c's .probe_new()
  media: i2c/adv7170: Convert to i2c's .probe_new()
  media: i2c/adv7175: Convert to i2c's .probe_new()
  media: i2c/adv7180: Convert to i2c's .probe_new()
  media: i2c/adv7183: Convert to i2c's .probe_new()
  media: i2c/adv7393: Convert to i2c's .probe_new()
  media: i2c/adv7511-v4l2: Convert to i2c's .probe_new()
  media: i2c/adv7604: Convert to i2c's .probe_new()
  media: i2c/adv7842: Convert to i2c's .probe_new()
  media: i2c/ak881x: Convert to i2c's .probe_new()
  media: i2c/bt819: Convert to i2c's .probe_new()
  media: i2c/bt856: Convert to i2c's .probe_new()
  media: i2c/bt866: Convert to i2c's .probe_new()
  media: i2c/cs3308: Convert to i2c's .probe_new()
  media: i2c/cs5345: Convert to i2c's .probe_new()
  media: i2c/cs53l32a: Convert to i2c's .probe_new()
  media: cx25840: Convert to i2c's .probe_new()
  media: i2c/ir-kbd-i2c: Convert to i2c's .probe_new()
  media: i2c/ks0127: Convert to i2c's .probe_new()
  media: i2c/lm3560: Convert to i2c's .probe_new()
  media: i2c/lm3646: Convert to i2c's .probe_new()
  media: i2c/m52790: Convert to i2c's .probe_new()
  media: m5mols: Convert to i2c's .probe_new()
  media: i2c/ml86v7667: Convert to i2c's .probe_new()
  media: i2c/msp3400-driver: Convert to i2c's .probe_new()
  media: i2c/mt9m032: Convert to i2c's .probe_new()
  media: i2c/mt9p031: Convert to i2c's .probe_new()
  media: i2c/mt9t001: Convert to i2c's .probe_new()
  media: i2c/mt9t112: Convert to i2c's .probe_new()
  media: i2c/mt9v011: Convert to i2c's .probe_new()
  media: i2c/mt9v032: Convert to i2c's .probe_new()
  media: i2c/noon010pc30: Convert to i2c's .probe_new()
  media: i2c/ov13858: Convert to i2c's .probe_new()
  media: i2c/ov6650: Convert to i2c's .probe_new()
  media: i2c/ov7640: Convert to i2c's .probe_new()
  media: i2c/ov7670: Convert to i2c's .probe_new()
  media: i2c/ov9640: Convert to i2c's .probe_new()
  media: i2c/rj54n1cb0c: Convert to i2c's .probe_new()
  media: i2c/s5k4ecgx: Convert to i2c's .probe_new()
  media: i2c/s5k6aa: Convert to i2c's .probe_new()
  media: i2c/saa6588: Convert to i2c's .probe_new()
  media: i2c/saa6752hs: Convert to i2c's .probe_new()
  media: i2c/saa7110: Convert to i2c's .probe_new()
  media: i2c/saa7115: Convert to i2c's .probe_new()
  media: i2c/saa7127: Convert to i2c's .probe_new()
  media: i2c/saa717x: Convert to i2c's .probe_new()
  media: i2c/saa7185: Convert to i2c's .probe_new()
  media: i2c/sony-btf-mpx: Convert to i2c's .probe_new()
  media: i2c/sr030pc30: Convert to i2c's .probe_new()
  media: i2c/tda1997x: Convert to i2c's .probe_new()
  media: i2c/tda7432: Convert to i2c's .probe_new()
  media: i2c/tda9840: Convert to i2c's .probe_new()
  media: i2c/tea6415c: Convert to i2c's .probe_new()
  media: i2c/tea6420: Convert to i2c's .probe_new()
  media: i2c/ths7303: Convert to i2c's .probe_new()
  media: i2c/tlv320aic23b: Convert to i2c's .probe_new()
  media: i2c/tvaudio: Convert to i2c's .probe_new()
  media: i2c/tvp514x: Convert to i2c's .probe_new()
  media: i2c/tw2804: Convert to i2c's .probe_new()
  media: i2c/tw9903: Convert to i2c's .probe_new()
  media: i2c/tw9906: Convert to i2c's .probe_new()
  media: i2c/tw9910: Convert to i2c's .probe_new()
  media: i2c/uda1342: Convert to i2c's .probe_new()
  media: i2c/upd64031a: Convert to i2c's .probe_new()
  media: i2c/upd64083: Convert to i2c's .probe_new()
  media: i2c/video-i2c: Convert to i2c's .probe_new()
  media: i2c/vp27smpx: Convert to i2c's .probe_new()
  media: i2c/vpx3220: Convert to i2c's .probe_new()
  media: i2c/vs6624: Convert to i2c's .probe_new()
  media: i2c/wm8739: Convert to i2c's .probe_new()
  media: i2c/wm8775: Convert to i2c's .probe_new()
  media: radio/radio-tea5764: Convert to i2c's .probe_new()
  media: radio/saa7706h: Convert to i2c's .probe_new()
  media: radio/tef6862: Convert to i2c's .probe_new()
  media: vidtv: Convert to i2c's .probe_new()
  media: tuners/e4000: Convert to i2c's .probe_new()
  media: tuners/fc2580: Convert to i2c's .probe_new()
  media: tuners/m88rs6000t: Convert to i2c's .probe_new()
  media: tuners/mt2060: Convert to i2c's .probe_new()
  media: tuners/mxl301rf: Convert to i2c's .probe_new()
  media: tuners/qm1d1b0004: Convert to i2c's .probe_new()
  media: tuners/qm1d1c0042: Convert to i2c's .probe_new()
  media: tuners/si2157: Convert to i2c's .probe_new()
  media: tuners/tda18212: Convert to i2c's .probe_new()
  media: tuners/tda18250: Convert to i2c's .probe_new()
  media: tuners/tua9001: Convert to i2c's .probe_new()
  media: usb: go7007: s2250-board: Convert to i2c's .probe_new()
  media: v4l2-core/tuner-core: Convert to i2c's .probe_new()
  mfd: 88pm800: Convert to i2c's .probe_new()
  mfd: 88pm805: Convert to i2c's .probe_new()
  mfd: aat2870-core: Convert to i2c's .probe_new()
  mfd: act8945a: Convert to i2c's .probe_new()
  mfd: adp5520: Convert to i2c's .probe_new()
  mfd: arizona-i2c: Convert to i2c's .probe_new()
  mfd: as3711: Convert to i2c's .probe_new()
  mfd: as3722: Convert to i2c's .probe_new()
  mfd: atc260x-i2c: Convert to i2c's .probe_new()
  mfd: axp20x-i2c: Convert to i2c's .probe_new()
  mfd: bcm590xx: Convert to i2c's .probe_new()
  mfd: bd9571mwv: Convert to i2c's .probe_new()
  mfd: da903x: Convert to i2c's .probe_new()
  mfd: da9052-i2c: Convert to i2c's .probe_new()
  mfd: da9055-i2c: Convert to i2c's .probe_new()
  mfd: da9062-core: Convert to i2c's .probe_new()
  mfd: da9063-i2c: Convert to i2c's .probe_new()
  mfd: da9150-core: Convert to i2c's .probe_new()
  mfd: khadas-mcu: Convert to i2c's .probe_new()
  mfd: lm3533-core: Convert to i2c's .probe_new()
  mfd: lp3943: Convert to i2c's .probe_new()
  mfd: lp873x: Convert to i2c's .probe_new()
  mfd: lp87565: Convert to i2c's .probe_new()
  mfd: lp8788: Convert to i2c's .probe_new()
  mfd: madera-i2c: Convert to i2c's .probe_new()
  mfd: max14577: Convert to i2c's .probe_new()
  mfd: max77620: Convert to i2c's .probe_new()
  mfd: max77693: Convert to i2c's .probe_new()
  mfd: max77843: Convert to i2c's .probe_new()
  mfd: max8907: Convert to i2c's .probe_new()
  mfd: max8925-i2c: Convert to i2c's .probe_new()
  mfd: max8997: Convert to i2c's .probe_new()
  mfd: max8998: Convert to i2c's .probe_new()
  mfd: mc13xxx-i2c: Convert to i2c's .probe_new()
  mfd: menelaus: Convert to i2c's .probe_new()
  mfd: menf21bmc: Convert to i2c's .probe_new()
  mfd: palmas: Convert to i2c's .probe_new()
  mfd: pcf50633-core: Convert to i2c's .probe_new()
  mfd: rc5t583: Convert to i2c's .probe_new()
  mfd: retu-mfd: Convert to i2c's .probe_new()
  mfd: rk808: Convert to i2c's .probe_new()
  mfd: rohm-bd718x7: Convert to i2c's .probe_new()
  mfd: rsmu_i2c: Convert to i2c's .probe_new()
  mfd: rt5033: Convert to i2c's .probe_new()
  mfd: sec-core: Convert to i2c's .probe_new()
  mfd: si476x-i2c: Convert to i2c's .probe_new()
  mfd: sky81452: Convert to i2c's .probe_new()
  mfd: stmfx: Convert to i2c's .probe_new()
  mfd: stmpe-i2c: Convert to i2c's .probe_new()
  mfd: stpmic1: Convert to i2c's .probe_new()
  mfd: stw481x: Convert to i2c's .probe_new()
  mfd: tc3589x: Convert to i2c's .probe_new()
  mfd: ti-lmu: Convert to i2c's .probe_new()
  mfd: tps6105x: Convert to i2c's .probe_new()
  mfd: tps65010: Convert to i2c's .probe_new()
  mfd: tps6507x: Convert to i2c's .probe_new()
  mfd: tps65086: Convert to i2c's .probe_new()
  mfd: tps65090: Convert to i2c's .probe_new()
  mfd: tps65218: Convert to i2c's .probe_new()
  mfd: tps6586x: Convert to i2c's .probe_new()
  mfd: tps65910: Convert to i2c's .probe_new()
  mfd: tps65912-i2c: Convert to i2c's .probe_new()
  mfd: twl-core: Convert to i2c's .probe_new()
  mfd: twl6040: Convert to i2c's .probe_new()
  mfd: wl1273-core: Convert to i2c's .probe_new()
  mfd: wm831x-i2c: Convert to i2c's .probe_new()
  mfd: wm8350-i2c: Convert to i2c's .probe_new()
  mfd: wm8400-core: Convert to i2c's .probe_new()
  mfd: wm8994-core: Convert to i2c's .probe_new()
  misc: ad525x_dpot-i2c: Convert to i2c's .probe_new()
  misc: apds9802als: Convert to i2c's .probe_new()
  misc: apds990x: Convert to i2c's .probe_new()
  misc: bh1770glc: Convert to i2c's .probe_new()
  misc: ds1682: Convert to i2c's .probe_new()
  misc: eeprom/eeprom: Convert to i2c's .probe_new()
  misc: eeprom/idt_89hpesx: Convert to i2c's .probe_new()
  misc: eeprom/max6875: Convert to i2c's .probe_new()
  misc: hmc6352: Convert to i2c's .probe_new()
  misc: ics932s401: Convert to i2c's .probe_new()
  misc: isl29003: Convert to i2c's .probe_new()
  misc: isl29020: Convert to i2c's .probe_new()
  misc: lis3lv02d/lis3lv02d_i2c: Convert to i2c's .probe_new()
  misc: tsl2550: Convert to i2c's .probe_new()
  mtd: maps: pismo: Convert to i2c's .probe_new()
  net: dsa: lan9303: Convert to i2c's .probe_new()
  net: dsa: microchip: ksz9477: Convert to i2c's .probe_new()
  net: dsa: xrs700x: Convert to i2c's .probe_new()
  net/mlx5: Convert to i2c's .probe_new()
  nfc: microread: Convert to i2c's .probe_new()
  nfc: mrvl: Convert to i2c's .probe_new()
  NFC: nxp-nci: Convert to i2c's .probe_new()
  nfc: pn533: Convert to i2c's .probe_new()
  nfc: pn544: Convert to i2c's .probe_new()
  nfc: s3fwrn5: Convert to i2c's .probe_new()
  nfc: st-nci: Convert to i2c's .probe_new()
  nfc: st21nfca: i2c: Convert to i2c's .probe_new()
  of: unittest: Convert to i2c's .probe_new()
  pinctrl: mcp23s08: Convert to i2c's .probe_new()
  pinctrl: sx150x: Convert to i2c's .probe_new()
  platform/chrome: cros_ec: Convert to i2c's .probe_new()
  power: supply: adp5061: Convert to i2c's .probe_new()
  power: supply: bq2415x: Convert to i2c's .probe_new()
  power: supply: bq24190: Convert to i2c's .probe_new()
  power: supply: bq24257: Convert to i2c's .probe_new()
  power: supply: bq24735: Convert to i2c's .probe_new()
  power: supply: bq2515x: Convert to i2c's .probe_new()
  power: supply: bq256xx: Convert to i2c's .probe_new()
  power: supply: bq25890: Convert to i2c's .probe_new()
  power: supply: bq25980: Convert to i2c's .probe_new()
  power: supply: bq27xxx: Convert to i2c's .probe_new()
  power: supply: ds2782: Convert to i2c's .probe_new()
  power: supply: lp8727: Convert to i2c's .probe_new()
  power: supply: ltc2941: Convert to i2c's .probe_new()
  power: supply: ltc4162-l: Convert to i2c's .probe_new()
  power: supply: max14656: Convert to i2c's .probe_new()
  power: supply: max17040: Convert to i2c's .probe_new()
  power: supply: max17042_battery: Convert to i2c's .probe_new()
  power: supply: rt5033_battery: Convert to i2c's .probe_new()
  power: supply: rt9455: Convert to i2c's .probe_new()
  power: supply: sbs: Convert to i2c's .probe_new()
  power: supply: sbs-manager: Convert to i2c's .probe_new()
  power: supply: smb347: Convert to i2c's .probe_new()
  power: supply: ucs1002: Convert to i2c's .probe_new()
  power: supply: z2_battery: Convert to i2c's .probe_new()
  pwm: pca9685: Convert to i2c's .probe_new()
  regulator: act8865-regulator: Convert to i2c's .probe_new()
  regulator: ad5398: Convert to i2c's .probe_new()
  regulator: da9121-regulator: Convert to i2c's .probe_new()
  regulator: fan53555: Convert to i2c's .probe_new()
  regulator: isl6271a-regulator: Convert to i2c's .probe_new()
  regulator: lp3972: Convert to i2c's .probe_new()
  regulator: lp872x: Convert to i2c's .probe_new()
  regulator: lp8755: Convert to i2c's .probe_new()
  regulator: ltc3589: Convert to i2c's .probe_new()
  regulator: max1586: Convert to i2c's .probe_new()
  regulator: max8649: Convert to i2c's .probe_new()
  regulator: max8660: Convert to i2c's .probe_new()
  regulator: max8952: Convert to i2c's .probe_new()
  regulator: max8973-regulator: Convert to i2c's .probe_new()
  regulator: pca9450-regulator: Convert to i2c's .probe_new()
  regulator: pfuze100-regulator: Convert to i2c's .probe_new()
  regulator: pv88080-regulator: Convert to i2c's .probe_new()
  regulator: rpi-panel-attiny-regulator: Convert to i2c's .probe_new()
  regulator: tps51632-regulator: Convert to i2c's .probe_new()
  regulator: tps62360-regulator: Convert to i2c's .probe_new()
  regulator: tps6286x-regulator: Convert to i2c's .probe_new()
  regulator: tps65023-regulator: Convert to i2c's .probe_new()
  rtc: ds1307: Convert to i2c's .probe_new()
  rtc: isl1208: Convert to i2c's .probe_new()
  rtc: m41t80: Convert to i2c's .probe_new()
  rtc: rs5c372: Convert to i2c's .probe_new()
  spi: sc18is602: Convert to i2c's .probe_new()
  spi: xcomm: Convert to i2c's .probe_new()
  staging: iio: adt7316: Convert to i2c's .probe_new()
  staging: iio: ad5933: Convert to i2c's .probe_new()
  staging: iio: ade7854: Convert to i2c's .probe_new()
  staging: most: i2c: Convert to i2c's .probe_new()
  staging: olpc_dcon: Convert to i2c's .probe_new()
  serial: sc16is7xx: Convert to i2c's .probe_new()
  usb: usb251xb: Convert to i2c's .probe_new()
  usb: misc: usb3503: Convert to i2c's .probe_new()
  usb: usb4604: Convert to i2c's .probe_new()
  usb: isp1301-omap: Convert to i2c's .probe_new()
  usb: phy: isp1301: Convert to i2c's .probe_new()
  usb: typec: anx7411: Convert to i2c's .probe_new()
  usb: typec: hd3ss3220: Convert to i2c's .probe_new()
  usb: typec: tcpm/fusb302: Convert to i2c's .probe_new()
  usb: typec: tcpm/tcpci: Convert to i2c's .probe_new()
  usb: typec: tcpm/tcpci_maxim: Convert to i2c's .probe_new()
  usb: typec: tcpm/tcpci_rt1711h: Convert to i2c's .probe_new()
  usb: typec: ucsi/ucsi_ccg: Convert to i2c's .probe_new()
  usb: typec: ucsi: stm32g0: Convert to i2c's .probe_new()
  backlight: adp8860: Convert to i2c's .probe_new()
  backlight: adp8870: Convert to i2c's .probe_new()
  backlight: arcxcnn: Convert to i2c's .probe_new()
  backlight: bd6107: Convert to i2c's .probe_new()
  backlight: lm3630a: Convert to i2c's .probe_new()
  backlight: lm3639: Convert to i2c's .probe_new()
  backlight: lp855x: Convert to i2c's .probe_new()
  backlight: lv5207lp: Convert to i2c's .probe_new()
  backlight: tosa: Convert to i2c's .probe_new()
  video: fbdev: matrox: Convert to i2c's .probe_new()
  w1: ds2482: Convert to i2c's .probe_new()
  watchdog: ziirave_wdt: Convert to i2c's .probe_new()
  ALSA: aoa: onyx: Convert to i2c's .probe_new()
  ALSA: aoa: tas: Convert to i2c's .probe_new()
  ALSA: hda: cs35l41: Convert to i2c's .probe_new()
  ALSA: ppc: keywest: Convert to i2c's .probe_new()
  ASoC: codecs: es8326: Convert to i2c's .probe_new()
  ASoC: max98396: Convert to i2c's .probe_new()
  ASoC: codecs: src4xxx-i2c: Convert to i2c's .probe_new()
  ASoC: codecs: tas2780: Convert to i2c's .probe_new()
  ipmi: ssif_bmc: Convert to i2c's .probe_new()
  [DON'T APPLY] i2c: Switch .probe() to not take an id parameter

 drivers/char/ipmi/ssif_bmc.c                     |  4 ++--
 drivers/char/tpm/st33zp24/i2c.c                  |  5 ++---
 drivers/char/tpm/tpm_i2c_atmel.c                 |  5 ++---
 drivers/char/tpm/tpm_i2c_infineon.c              |  5 ++---
 drivers/char/tpm/tpm_i2c_nuvoton.c               |  6 +++---
 drivers/char/tpm/tpm_tis_i2c.c                   |  5 ++---
 drivers/crypto/atmel-ecc.c                       |  6 +++---
 drivers/crypto/atmel-sha204a.c                   |  6 +++---
 drivers/extcon/extcon-fsa9480.c                  |  5 ++---
 drivers/extcon/extcon-rt8973a.c                  |  5 ++---
 drivers/extcon/extcon-usbc-tusb320.c             |  5 ++---
 drivers/gpio/gpio-max732x.c                      |  6 +++---
 drivers/gpio/gpio-pca953x.c                      |  6 +++---
 drivers/gpio/gpio-pcf857x.c                      |  6 +++---
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c     |  5 +++--
 .../gpu/drm/bridge/analogix/analogix-anx6345.c   |  5 ++---
 .../gpu/drm/bridge/analogix/analogix-anx78xx.c   |  5 ++---
 drivers/gpu/drm/bridge/analogix/anx7625.c        |  5 ++---
 drivers/gpu/drm/bridge/chipone-icn6211.c         |  5 ++---
 drivers/gpu/drm/bridge/chrontel-ch7033.c         |  5 ++---
 drivers/gpu/drm/bridge/ite-it6505.c              |  5 ++---
 drivers/gpu/drm/bridge/ite-it66121.c             |  5 ++---
 drivers/gpu/drm/bridge/lontium-lt8912b.c         |  5 ++---
 drivers/gpu/drm/bridge/lontium-lt9211.c          |  5 ++---
 drivers/gpu/drm/bridge/lontium-lt9611.c          |  5 ++---
 drivers/gpu/drm/bridge/lontium-lt9611uxc.c       |  5 ++---
 .../drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c | 10 ++++------
 drivers/gpu/drm/bridge/nxp-ptn3460.c             |  5 ++---
 drivers/gpu/drm/bridge/parade-ps8622.c           |  6 +++---
 drivers/gpu/drm/bridge/sii902x.c                 |  5 ++---
 drivers/gpu/drm/bridge/sii9234.c                 |  5 ++---
 drivers/gpu/drm/bridge/sil-sii8620.c             |  5 ++---
 drivers/gpu/drm/bridge/tc358767.c                |  4 ++--
 drivers/gpu/drm/bridge/tc358768.c                |  5 ++---
 drivers/gpu/drm/bridge/tc358775.c                |  4 ++--
 drivers/gpu/drm/bridge/ti-sn65dsi83.c            |  6 +++---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c            |  5 ++---
 drivers/gpu/drm/bridge/ti-tfp410.c               |  5 ++---
 drivers/gpu/drm/i2c/ch7006_drv.c                 |  4 ++--
 drivers/gpu/drm/i2c/sil164_drv.c                 |  4 ++--
 drivers/gpu/drm/i2c/tda9950.c                    |  5 ++---
 drivers/gpu/drm/i2c/tda998x_drv.c                |  4 ++--
 .../gpu/drm/panel/panel-olimex-lcd-olinuxino.c   |  5 ++---
 .../drm/panel/panel-raspberrypi-touchscreen.c    |  5 ++---
 drivers/i2c/i2c-core-base.c                      | 16 ++++------------
 drivers/i2c/i2c-slave-eeprom.c                   |  5 +++--
 drivers/i2c/i2c-smbus.c                          |  5 ++---
 drivers/i2c/muxes/i2c-mux-pca9541.c              |  5 ++---
 drivers/i2c/muxes/i2c-mux-pca954x.c              |  6 +++---
 drivers/iio/accel/adxl372_i2c.c                  |  6 +++---
 drivers/iio/accel/bma180.c                       |  6 +++---
 drivers/iio/accel/bma400_i2c.c                   |  6 +++---
 drivers/iio/accel/bmc150-accel-i2c.c             |  6 +++---
 drivers/iio/accel/da280.c                        |  6 +++---
 drivers/iio/accel/kxcjk-1013.c                   |  6 +++---
 drivers/iio/accel/mma7455_i2c.c                  |  6 +++---
 drivers/iio/accel/mma8452.c                      |  6 +++---
 drivers/iio/accel/mma9551.c                      |  6 +++---
 drivers/iio/accel/mma9553.c                      |  6 +++---
 drivers/iio/adc/ad7091r5.c                       |  6 +++---
 drivers/iio/adc/ad7291.c                         |  6 +++---
 drivers/iio/adc/ad799x.c                         |  6 +++---
 drivers/iio/adc/ina2xx-adc.c                     |  6 +++---
 drivers/iio/adc/ltc2471.c                        |  6 +++---
 drivers/iio/adc/ltc2485.c                        |  6 +++---
 drivers/iio/adc/ltc2497.c                        |  6 +++---
 drivers/iio/adc/max1363.c                        |  6 +++---
 drivers/iio/adc/max9611.c                        |  5 ++---
 drivers/iio/adc/mcp3422.c                        |  6 +++---
 drivers/iio/adc/ti-adc081c.c                     |  6 +++---
 drivers/iio/adc/ti-ads1015.c                     |  6 +++---
 drivers/iio/cdc/ad7150.c                         |  6 +++---
 drivers/iio/cdc/ad7746.c                         |  6 +++---
 drivers/iio/chemical/ams-iaq-core.c              |  5 ++---
 drivers/iio/chemical/atlas-ezo-sensor.c          |  6 +++---
 drivers/iio/chemical/atlas-sensor.c              |  6 +++---
 drivers/iio/chemical/bme680_i2c.c                |  6 +++---
 drivers/iio/chemical/ccs811.c                    |  6 +++---
 drivers/iio/chemical/scd4x.c                     |  4 ++--
 drivers/iio/chemical/sgp30.c                     |  6 +++---
 drivers/iio/chemical/sgp40.c                     |  6 +++---
 drivers/iio/chemical/vz89x.c                     |  6 +++---
 drivers/iio/dac/ad5064.c                         |  6 +++---
 drivers/iio/dac/ad5380.c                         |  6 +++---
 drivers/iio/dac/ad5446.c                         |  6 +++---
 drivers/iio/dac/ad5593r.c                        |  6 +++---
 drivers/iio/dac/ad5696-i2c.c                     |  6 +++---
 drivers/iio/dac/ds4424.c                         |  6 +++---
 drivers/iio/dac/m62332.c                         |  5 ++---
 drivers/iio/dac/max517.c                         |  6 +++---
 drivers/iio/dac/max5821.c                        |  6 +++---
 drivers/iio/dac/mcp4725.c                        |  6 +++---
 drivers/iio/dac/ti-dac5571.c                     |  6 +++---
 drivers/iio/gyro/bmg160_i2c.c                    |  6 +++---
 drivers/iio/gyro/itg3200_core.c                  |  5 ++---
 drivers/iio/gyro/mpu3050-i2c.c                   |  6 +++---
 drivers/iio/gyro/st_gyro_i2c.c                   |  5 ++---
 drivers/iio/health/afe4404.c                     |  5 ++---
 drivers/iio/health/max30100.c                    |  5 ++---
 drivers/iio/health/max30102.c                    |  6 +++---
 drivers/iio/humidity/am2315.c                    |  5 ++---
 drivers/iio/humidity/hdc100x.c                   |  5 ++---
 drivers/iio/humidity/hdc2010.c                   |  5 ++---
 drivers/iio/humidity/hts221_i2c.c                |  5 ++---
 drivers/iio/humidity/htu21.c                     |  6 +++---
 drivers/iio/humidity/si7005.c                    |  5 ++---
 drivers/iio/humidity/si7020.c                    |  5 ++---
 drivers/iio/imu/bmi160/bmi160_i2c.c              |  6 +++---
 drivers/iio/imu/fxos8700_i2c.c                   |  6 +++---
 drivers/iio/imu/inv_mpu6050/inv_mpu_i2c.c        |  6 +++---
 drivers/iio/imu/kmx61.c                          |  6 +++---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_i2c.c      |  6 +++---
 drivers/iio/light/adjd_s311.c                    |  5 ++---
 drivers/iio/light/adux1020.c                     |  5 ++---
 drivers/iio/light/al3010.c                       |  5 ++---
 drivers/iio/light/al3320a.c                      |  5 ++---
 drivers/iio/light/apds9300.c                     |  5 ++---
 drivers/iio/light/apds9960.c                     |  5 ++---
 drivers/iio/light/bh1750.c                       |  6 +++---
 drivers/iio/light/bh1780.c                       |  5 ++---
 drivers/iio/light/cm3232.c                       |  6 +++---
 drivers/iio/light/cm3323.c                       |  5 ++---
 drivers/iio/light/cm36651.c                      |  6 +++---
 drivers/iio/light/gp2ap002.c                     |  5 ++---
 drivers/iio/light/gp2ap020a00f.c                 |  6 +++---
 drivers/iio/light/isl29018.c                     |  6 +++---
 drivers/iio/light/isl29028.c                     |  6 +++---
 drivers/iio/light/isl29125.c                     |  5 ++---
 drivers/iio/light/jsa1212.c                      |  5 ++---
 drivers/iio/light/ltr501.c                       |  6 +++---
 drivers/iio/light/lv0104cs.c                     |  5 ++---
 drivers/iio/light/max44000.c                     |  5 ++---
 drivers/iio/light/max44009.c                     |  5 ++---
 drivers/iio/light/noa1305.c                      |  5 ++---
 drivers/iio/light/opt3001.c                      |  5 ++---
 drivers/iio/light/pa12203001.c                   |  5 ++---
 drivers/iio/light/rpr0521.c                      |  5 ++---
 drivers/iio/light/si1133.c                       |  6 +++---
 drivers/iio/light/si1145.c                       |  6 +++---
 drivers/iio/light/st_uvis25_i2c.c                |  5 ++---
 drivers/iio/light/stk3310.c                      |  5 ++---
 drivers/iio/light/tcs3414.c                      |  5 ++---
 drivers/iio/light/tcs3472.c                      |  5 ++---
 drivers/iio/light/tsl2563.c                      |  5 ++---
 drivers/iio/light/tsl2583.c                      |  5 ++---
 drivers/iio/light/tsl2772.c                      |  6 +++---
 drivers/iio/light/tsl4531.c                      |  5 ++---
 drivers/iio/light/us5182d.c                      |  5 ++---
 drivers/iio/light/vcnl4000.c                     |  6 +++---
 drivers/iio/light/vcnl4035.c                     |  5 ++---
 drivers/iio/light/veml6030.c                     |  5 ++---
 drivers/iio/light/veml6070.c                     |  5 ++---
 drivers/iio/light/zopt2201.c                     |  5 ++---
 drivers/iio/magnetometer/ak8974.c                |  5 ++---
 drivers/iio/magnetometer/ak8975.c                |  6 +++---
 drivers/iio/magnetometer/bmc150_magn_i2c.c       |  6 +++---
 drivers/iio/magnetometer/hmc5843_i2c.c           |  6 +++---
 drivers/iio/magnetometer/mag3110.c               |  6 +++---
 drivers/iio/magnetometer/mmc35240.c              |  5 ++---
 drivers/iio/magnetometer/yamaha-yas530.c         |  6 +++---
 drivers/iio/potentiometer/ad5272.c               |  6 +++---
 drivers/iio/potentiometer/ds1803.c               |  5 +++--
 drivers/iio/potentiometer/max5432.c              |  5 ++---
 drivers/iio/potentiometer/tpl0102.c              |  6 +++---
 drivers/iio/potentiostat/lmp91000.c              |  5 ++---
 drivers/iio/pressure/abp060mg.c                  |  6 +++---
 drivers/iio/pressure/bmp280-i2c.c                |  1 +
 drivers/iio/pressure/dlhl60d.c                   |  6 +++---
 drivers/iio/pressure/dps310.c                    |  6 +++---
 drivers/iio/pressure/hp03.c                      |  6 +++---
 drivers/iio/pressure/hp206c.c                    |  6 +++---
 drivers/iio/pressure/icp10100.c                  |  5 ++---
 drivers/iio/pressure/mpl115_i2c.c                |  6 +++---
 drivers/iio/pressure/mpl3115.c                   |  6 +++---
 drivers/iio/pressure/ms5611_i2c.c                |  6 +++---
 drivers/iio/pressure/ms5637.c                    |  6 +++---
 drivers/iio/pressure/st_pressure_i2c.c           |  5 ++---
 drivers/iio/pressure/t5403.c                     |  6 +++---
 drivers/iio/pressure/zpa2326_i2c.c               |  6 +++---
 drivers/iio/proximity/isl29501.c                 |  5 ++---
 drivers/iio/proximity/mb1232.c                   |  6 +++---
 .../iio/proximity/pulsedlight-lidar-lite-v2.c    |  5 ++---
 drivers/iio/proximity/rfd77402.c                 |  5 ++---
 drivers/iio/proximity/srf08.c                    |  6 +++---
 drivers/iio/proximity/sx9500.c                   |  5 ++---
 drivers/iio/temperature/mlx90614.c               |  6 +++---
 drivers/iio/temperature/mlx90632.c               | 12 ++++++++++--
 drivers/iio/temperature/tmp006.c                 |  5 ++---
 drivers/iio/temperature/tmp007.c                 |  6 +++---
 drivers/iio/temperature/tsys01.c                 |  5 ++---
 drivers/iio/temperature/tsys02d.c                |  6 +++---
 drivers/input/joystick/as5011.c                  |  5 ++---
 drivers/input/keyboard/adp5588-keys.c            |  5 ++---
 drivers/input/keyboard/adp5589-keys.c            |  6 +++---
 drivers/input/keyboard/cap11xx.c                 |  6 +++---
 drivers/input/keyboard/dlink-dir685-touchkeys.c  |  5 ++---
 drivers/input/keyboard/lm8323.c                  |  5 ++---
 drivers/input/keyboard/lm8333.c                  |  5 ++---
 drivers/input/keyboard/max7359_keypad.c          |  5 ++---
 drivers/input/keyboard/mcs_touchkey.c            |  6 +++---
 drivers/input/keyboard/mpr121_touchkey.c         |  5 ++---
 drivers/input/keyboard/qt1070.c                  |  5 ++---
 drivers/input/keyboard/qt2160.c                  |  5 ++---
 drivers/input/keyboard/tca6416-keypad.c          |  6 +++---
 drivers/input/keyboard/tca8418_keypad.c          |  5 ++---
 drivers/input/keyboard/tm2-touchkey.c            |  5 ++---
 drivers/input/misc/ad714x-i2c.c                  |  5 ++---
 drivers/input/misc/adxl34x-i2c.c                 |  5 ++---
 drivers/input/misc/apanel.c                      |  5 ++---
 drivers/input/misc/atmel_captouch.c              |  5 ++---
 drivers/input/misc/bma150.c                      |  5 ++---
 drivers/input/misc/cma3000_d0x_i2c.c             |  5 ++---
 drivers/input/misc/da7280.c                      |  5 ++---
 drivers/input/misc/drv260x.c                     |  5 ++---
 drivers/input/misc/drv2665.c                     |  5 ++---
 drivers/input/misc/drv2667.c                     |  5 ++---
 drivers/input/misc/ibm-panel.c                   |  5 ++---
 drivers/input/misc/kxtj9.c                       |  5 ++---
 drivers/input/misc/mma8450.c                     |  5 ++---
 drivers/input/misc/pcf8574_keypad.c              |  4 ++--
 drivers/input/mouse/cyapa.c                      |  5 ++---
 drivers/input/mouse/elan_i2c_core.c              |  5 ++---
 drivers/input/mouse/synaptics_i2c.c              |  5 ++---
 drivers/input/rmi4/rmi_i2c.c                     |  5 ++---
 drivers/input/rmi4/rmi_smbus.c                   |  5 ++---
 drivers/input/touchscreen/ad7879-i2c.c           |  5 ++---
 drivers/input/touchscreen/ar1021_i2c.c           |  5 ++---
 drivers/input/touchscreen/atmel_mxt_ts.c         |  4 ++--
 drivers/input/touchscreen/auo-pixcir-ts.c        |  5 ++---
 drivers/input/touchscreen/bu21013_ts.c           |  5 ++---
 drivers/input/touchscreen/bu21029_ts.c           |  5 ++---
 drivers/input/touchscreen/chipone_icn8318.c      |  5 ++---
 drivers/input/touchscreen/cy8ctma140.c           |  5 ++---
 drivers/input/touchscreen/cy8ctmg110_ts.c        |  5 ++---
 drivers/input/touchscreen/cyttsp4_i2c.c          |  5 ++---
 drivers/input/touchscreen/cyttsp5.c              |  5 ++---
 drivers/input/touchscreen/cyttsp_i2c.c           |  5 ++---
 drivers/input/touchscreen/edt-ft5x06.c           |  6 +++---
 drivers/input/touchscreen/eeti_ts.c              |  5 ++---
 drivers/input/touchscreen/egalax_ts.c            |  5 ++---
 drivers/input/touchscreen/ektf2127.c             |  5 ++---
 drivers/input/touchscreen/goodix.c               |  5 ++---
 drivers/input/touchscreen/hideep.c               |  5 ++---
 drivers/input/touchscreen/himax_hx83112b.c       |  5 ++---
 drivers/input/touchscreen/hycon-hy46xx.c         |  5 ++---
 drivers/input/touchscreen/ili210x.c              |  6 +++---
 drivers/input/touchscreen/ilitek_ts_i2c.c        |  5 ++---
 drivers/input/touchscreen/iqs5xx.c               |  5 ++---
 drivers/input/touchscreen/max11801_ts.c          |  5 ++---
 drivers/input/touchscreen/mcs5000_ts.c           |  5 ++---
 drivers/input/touchscreen/melfas_mip4.c          |  4 ++--
 drivers/input/touchscreen/migor_ts.c             |  5 ++---
 drivers/input/touchscreen/mms114.c               |  5 ++---
 drivers/input/touchscreen/pixcir_i2c_ts.c        |  6 +++---
 drivers/input/touchscreen/raydium_i2c_ts.c       |  5 ++---
 drivers/input/touchscreen/rohm_bu21023.c         |  5 ++---
 drivers/input/touchscreen/s6sy761.c              |  5 ++---
 drivers/input/touchscreen/silead.c               |  6 +++---
 drivers/input/touchscreen/sis_i2c.c              |  5 ++---
 drivers/input/touchscreen/st1232.c               |  6 +++---
 drivers/input/touchscreen/stmfts.c               |  5 ++---
 drivers/input/touchscreen/sx8654.c               |  6 +++---
 drivers/input/touchscreen/tsc2004.c              |  5 ++---
 drivers/input/touchscreen/tsc2007_core.c         |  6 +++---
 drivers/input/touchscreen/wacom_i2c.c            |  5 ++---
 drivers/input/touchscreen/wdt87xx_i2c.c          |  5 ++---
 drivers/input/touchscreen/zet6223.c              |  5 ++---
 drivers/input/touchscreen/zforce_ts.c            |  5 ++---
 drivers/leds/leds-bd2802.c                       |  5 ++---
 drivers/leds/leds-blinkm.c                       |  5 ++---
 drivers/leds/leds-is31fl32xx.c                   |  5 ++---
 drivers/leds/leds-lm3530.c                       |  5 ++---
 drivers/leds/leds-lm3532.c                       |  5 ++---
 drivers/leds/leds-lm355x.c                       |  6 +++---
 drivers/leds/leds-lm3642.c                       |  5 ++---
 drivers/leds/leds-lm3692x.c                      |  6 +++---
 drivers/leds/leds-lm3697.c                       |  5 ++---
 drivers/leds/leds-lp3944.c                       |  5 ++---
 drivers/leds/leds-lp3952.c                       |  5 ++---
 drivers/leds/leds-lp5521.c                       |  6 +++---
 drivers/leds/leds-lp5523.c                       |  6 +++---
 drivers/leds/leds-lp5562.c                       |  5 ++---
 drivers/leds/leds-lp8501.c                       |  6 +++---
 drivers/leds/leds-lp8860.c                       |  5 ++---
 drivers/leds/leds-pca9532.c                      |  9 ++++-----
 drivers/leds/leds-pca963x.c                      |  6 +++---
 drivers/leds/leds-tca6507.c                      |  5 ++---
 drivers/leds/leds-tlc591xx.c                     |  5 ++---
 drivers/leds/leds-turris-omnia.c                 |  5 ++---
 drivers/macintosh/ams/ams-i2c.c                  |  8 +++-----
 drivers/macintosh/therm_adt746x.c                |  6 +++---
 drivers/macintosh/therm_windtunnel.c             |  5 +++--
 drivers/macintosh/windfarm_ad7417_sensor.c       |  5 ++---
 drivers/macintosh/windfarm_fcu_controls.c        |  5 ++---
 drivers/macintosh/windfarm_lm75_sensor.c         |  8 ++++----
 drivers/macintosh/windfarm_lm87_sensor.c         |  5 ++---
 drivers/macintosh/windfarm_max6690_sensor.c      |  5 ++---
 drivers/macintosh/windfarm_smu_sat.c             |  5 ++---
 drivers/media/dvb-frontends/a8293.c              |  5 ++---
 drivers/media/dvb-frontends/af9013.c             |  5 ++---
 drivers/media/dvb-frontends/af9033.c             |  5 ++---
 drivers/media/dvb-frontends/au8522_decoder.c     |  5 ++---
 drivers/media/dvb-frontends/cxd2099.c            |  5 ++---
 drivers/media/dvb-frontends/cxd2820r_core.c      |  5 ++---
 drivers/media/dvb-frontends/dvb-pll.c            |  5 +++--
 drivers/media/dvb-frontends/helene.c             |  5 ++---
 drivers/media/dvb-frontends/lgdt3306a.c          |  5 ++---
 drivers/media/dvb-frontends/lgdt330x.c           |  5 ++---
 drivers/media/dvb-frontends/m88ds3103.c          |  6 +++---
 drivers/media/dvb-frontends/mn88443x.c           |  6 +++---
 drivers/media/dvb-frontends/mn88472.c            |  5 ++---
 drivers/media/dvb-frontends/mn88473.c            |  5 ++---
 drivers/media/dvb-frontends/mxl692.c             |  5 ++---
 drivers/media/dvb-frontends/rtl2830.c            |  5 ++---
 drivers/media/dvb-frontends/rtl2832.c            |  5 ++---
 drivers/media/dvb-frontends/si2165.c             |  5 ++---
 drivers/media/dvb-frontends/si2168.c             |  5 ++---
 drivers/media/dvb-frontends/sp2.c                |  5 ++---
 drivers/media/dvb-frontends/stv090x.c            |  5 ++---
 drivers/media/dvb-frontends/stv6110x.c           |  5 ++---
 drivers/media/dvb-frontends/tc90522.c            |  6 +++---
 drivers/media/dvb-frontends/tda10071.c           |  5 ++---
 drivers/media/dvb-frontends/ts2020.c             |  5 ++---
 drivers/media/i2c/ad5820.c                       |  5 ++---
 drivers/media/i2c/ad9389b.c                      |  4 ++--
 drivers/media/i2c/adp1653.c                      |  5 ++---
 drivers/media/i2c/adv7170.c                      |  5 ++---
 drivers/media/i2c/adv7175.c                      |  5 ++---
 drivers/media/i2c/adv7180.c                      |  6 +++---
 drivers/media/i2c/adv7183.c                      |  5 ++---
 drivers/media/i2c/adv7393.c                      |  5 ++---
 drivers/media/i2c/adv7511-v4l2.c                 |  4 ++--
 drivers/media/i2c/adv7604.c                      |  6 +++---
 drivers/media/i2c/adv7842.c                      |  5 ++---
 drivers/media/i2c/ak881x.c                       |  5 ++---
 drivers/media/i2c/bt819.c                        |  5 ++---
 drivers/media/i2c/bt856.c                        |  5 ++---
 drivers/media/i2c/bt866.c                        |  5 ++---
 drivers/media/i2c/cs3308.c                       |  5 ++---
 drivers/media/i2c/cs5345.c                       |  5 ++---
 drivers/media/i2c/cs53l32a.c                     |  6 +++---
 drivers/media/i2c/cx25840/cx25840-core.c         |  5 ++---
 drivers/media/i2c/ir-kbd-i2c.c                   |  5 +++--
 drivers/media/i2c/ks0127.c                       |  4 ++--
 drivers/media/i2c/lm3560.c                       |  5 ++---
 drivers/media/i2c/lm3646.c                       |  5 ++---
 drivers/media/i2c/m52790.c                       |  5 ++---
 drivers/media/i2c/m5mols/m5mols_core.c           |  5 ++---
 drivers/media/i2c/ml86v7667.c                    |  5 ++---
 drivers/media/i2c/msp3400-driver.c               |  5 +++--
 drivers/media/i2c/mt9m032.c                      |  5 ++---
 drivers/media/i2c/mt9p031.c                      |  6 +++---
 drivers/media/i2c/mt9t001.c                      |  5 ++---
 drivers/media/i2c/mt9t112.c                      |  5 ++---
 drivers/media/i2c/mt9v011.c                      |  5 ++---
 drivers/media/i2c/mt9v032.c                      |  6 +++---
 drivers/media/i2c/noon010pc30.c                  |  5 ++---
 drivers/media/i2c/ov13858.c                      |  5 ++---
 drivers/media/i2c/ov6650.c                       |  5 ++---
 drivers/media/i2c/ov7640.c                       |  5 ++---
 drivers/media/i2c/ov7670.c                       |  6 +++---
 drivers/media/i2c/ov9640.c                       |  5 ++---
 drivers/media/i2c/rj54n1cb0c.c                   |  5 ++---
 drivers/media/i2c/s5k4ecgx.c                     |  5 ++---
 drivers/media/i2c/s5k6aa.c                       |  5 ++---
 drivers/media/i2c/saa6588.c                      |  5 ++---
 drivers/media/i2c/saa6752hs.c                    |  5 ++---
 drivers/media/i2c/saa7110.c                      |  5 ++---
 drivers/media/i2c/saa7115.c                      |  6 +++---
 drivers/media/i2c/saa7127.c                      |  6 +++---
 drivers/media/i2c/saa717x.c                      |  5 ++---
 drivers/media/i2c/saa7185.c                      |  5 ++---
 drivers/media/i2c/sony-btf-mpx.c                 |  5 ++---
 drivers/media/i2c/sr030pc30.c                    |  5 ++---
 drivers/media/i2c/tda1997x.c                     |  6 +++---
 drivers/media/i2c/tda7432.c                      |  5 ++---
 drivers/media/i2c/tda9840.c                      |  5 ++---
 drivers/media/i2c/tea6415c.c                     |  5 ++---
 drivers/media/i2c/tea6420.c                      |  5 ++---
 drivers/media/i2c/ths7303.c                      |  5 ++---
 drivers/media/i2c/tlv320aic23b.c                 |  5 ++---
 drivers/media/i2c/tvaudio.c                      |  5 +++--
 drivers/media/i2c/tvp514x.c                      |  5 +++--
 drivers/media/i2c/tw2804.c                       |  5 ++---
 drivers/media/i2c/tw9903.c                       |  5 ++---
 drivers/media/i2c/tw9906.c                       |  5 ++---
 drivers/media/i2c/tw9910.c                       |  5 ++---
 drivers/media/i2c/uda1342.c                      |  5 ++---
 drivers/media/i2c/upd64031a.c                    |  5 ++---
 drivers/media/i2c/upd64083.c                     |  5 ++---
 drivers/media/i2c/video-i2c.c                    |  6 +++---
 drivers/media/i2c/vp27smpx.c                     |  5 ++---
 drivers/media/i2c/vpx3220.c                      |  5 ++---
 drivers/media/i2c/vs6624.c                       |  5 ++---
 drivers/media/i2c/wm8739.c                       |  5 ++---
 drivers/media/i2c/wm8775.c                       |  5 ++---
 drivers/media/radio/radio-tea5764.c              |  5 ++---
 drivers/media/radio/saa7706h.c                   |  5 ++---
 drivers/media/radio/tef6862.c                    |  5 ++---
 drivers/media/test-drivers/vidtv/vidtv_demod.c   |  5 ++---
 drivers/media/test-drivers/vidtv/vidtv_tuner.c   |  5 ++---
 drivers/media/tuners/e4000.c                     |  5 ++---
 drivers/media/tuners/fc2580.c                    |  5 ++---
 drivers/media/tuners/m88rs6000t.c                |  5 ++---
 drivers/media/tuners/mt2060.c                    |  5 ++---
 drivers/media/tuners/mxl301rf.c                  |  5 ++---
 drivers/media/tuners/qm1d1b0004.c                |  4 ++--
 drivers/media/tuners/qm1d1c0042.c                |  5 ++---
 drivers/media/tuners/si2157.c                    |  6 +++---
 drivers/media/tuners/tda18212.c                  |  5 ++---
 drivers/media/tuners/tda18250.c                  |  5 ++---
 drivers/media/tuners/tua9001.c                   |  5 ++---
 drivers/media/usb/go7007/s2250-board.c           |  5 ++---
 drivers/media/v4l2-core/tuner-core.c             |  5 ++---
 drivers/mfd/88pm800.c                            |  5 ++---
 drivers/mfd/88pm805.c                            |  5 ++---
 drivers/mfd/aat2870-core.c                       |  5 ++---
 drivers/mfd/act8945a.c                           |  5 ++---
 drivers/mfd/adp5520.c                            |  6 +++---
 drivers/mfd/arizona-i2c.c                        |  6 +++---
 drivers/mfd/as3711.c                             |  5 ++---
 drivers/mfd/as3722.c                             |  5 ++---
 drivers/mfd/atc260x-i2c.c                        |  5 ++---
 drivers/mfd/axp20x-i2c.c                         |  5 ++---
 drivers/mfd/bcm590xx.c                           |  5 ++---
 drivers/mfd/bd9571mwv.c                          |  5 ++---
 drivers/mfd/da903x.c                             |  6 +++---
 drivers/mfd/da9052-i2c.c                         |  6 +++---
 drivers/mfd/da9055-i2c.c                         |  5 ++---
 drivers/mfd/da9062-core.c                        |  6 +++---
 drivers/mfd/da9063-i2c.c                         |  6 +++---
 drivers/mfd/da9150-core.c                        |  5 ++---
 drivers/mfd/khadas-mcu.c                         |  5 ++---
 drivers/mfd/lm3533-core.c                        |  5 ++---
 drivers/mfd/lp3943.c                             |  4 ++--
 drivers/mfd/lp873x.c                             |  5 ++---
 drivers/mfd/lp87565.c                            |  5 ++---
 drivers/mfd/lp8788.c                             |  4 ++--
 drivers/mfd/madera-i2c.c                         |  6 +++---
 drivers/mfd/max14577.c                           |  6 +++---
 drivers/mfd/max77620.c                           |  6 +++---
 drivers/mfd/max77693.c                           |  6 +++---
 drivers/mfd/max77843.c                           |  6 +++---
 drivers/mfd/max8907.c                            |  5 ++---
 drivers/mfd/max8925-i2c.c                        |  5 ++---
 drivers/mfd/max8997.c                            |  6 +++---
 drivers/mfd/max8998.c                            |  6 +++---
 drivers/mfd/mc13xxx-i2c.c                        |  6 +++---
 drivers/mfd/menelaus.c                           |  5 ++---
 drivers/mfd/menf21bmc.c                          |  4 ++--
 drivers/mfd/palmas.c                             |  5 ++---
 drivers/mfd/pcf50633-core.c                      |  5 ++---
 drivers/mfd/rc5t583.c                            |  5 ++---
 drivers/mfd/retu-mfd.c                           |  4 ++--
 drivers/mfd/rk808.c                              |  5 ++---
 drivers/mfd/rohm-bd718x7.c                       |  5 ++---
 drivers/mfd/rsmu_i2c.c                           |  6 +++---
 drivers/mfd/rt5033.c                             |  5 ++---
 drivers/mfd/sec-core.c                           |  5 ++---
 drivers/mfd/si476x-i2c.c                         |  6 +++---
 drivers/mfd/sky81452.c                           |  5 ++---
 drivers/mfd/stmfx.c                              |  5 ++---
 drivers/mfd/stmpe-i2c.c                          |  5 +++--
 drivers/mfd/stpmic1.c                            |  5 ++---
 drivers/mfd/stw481x.c                            |  5 ++---
 drivers/mfd/tc3589x.c                            |  6 +++---
 drivers/mfd/ti-lmu.c                             |  5 +++--
 drivers/mfd/tps6105x.c                           |  5 ++---
 drivers/mfd/tps65010.c                           |  6 +++---
 drivers/mfd/tps6507x.c                           |  5 ++---
 drivers/mfd/tps65086.c                           |  5 ++---
 drivers/mfd/tps65090.c                           |  5 ++---
 drivers/mfd/tps65218.c                           |  5 ++---
 drivers/mfd/tps6586x.c                           |  5 ++---
 drivers/mfd/tps65910.c                           |  6 +++---
 drivers/mfd/tps65912-i2c.c                       |  5 ++---
 drivers/mfd/twl-core.c                           |  5 +++--
 drivers/mfd/twl6040.c                            |  5 ++---
 drivers/mfd/wl1273-core.c                        |  5 ++---
 drivers/mfd/wm831x-i2c.c                         |  6 +++---
 drivers/mfd/wm8350-i2c.c                         |  5 ++---
 drivers/mfd/wm8400-core.c                        |  5 ++---
 drivers/mfd/wm8994-core.c                        |  6 +++---
 drivers/misc/ad525x_dpot-i2c.c                   |  6 +++---
 drivers/misc/apds9802als.c                       |  5 ++---
 drivers/misc/apds990x.c                          |  5 ++---
 drivers/misc/bh1770glc.c                         |  5 ++---
 drivers/misc/ds1682.c                            |  5 ++---
 drivers/misc/eeprom/eeprom.c                     |  5 ++---
 drivers/misc/eeprom/idt_89hpesx.c                |  4 ++--
 drivers/misc/eeprom/max6875.c                    |  5 ++---
 drivers/misc/hmc6352.c                           |  5 ++---
 drivers/misc/ics932s401.c                        |  8 +++-----
 drivers/misc/isl29003.c                          |  5 ++---
 drivers/misc/isl29020.c                          |  5 ++---
 drivers/misc/lis3lv02d/lis3lv02d_i2c.c           |  5 ++---
 drivers/misc/tsl2550.c                           |  5 ++---
 drivers/mtd/maps/pismo.c                         |  5 ++---
 drivers/net/dsa/lan9303_i2c.c                    |  5 ++---
 drivers/net/dsa/microchip/ksz9477_i2c.c          |  5 ++---
 drivers/net/dsa/xrs700x/xrs700x_i2c.c            |  5 ++---
 drivers/net/ethernet/mellanox/mlxsw/i2c.c        |  6 +++---
 drivers/nfc/microread/i2c.c                      |  5 ++---
 drivers/nfc/nfcmrvl/i2c.c                        |  5 ++---
 drivers/nfc/nxp-nci/i2c.c                        |  5 ++---
 drivers/nfc/pn533/i2c.c                          |  5 ++---
 drivers/nfc/pn544/i2c.c                          |  5 ++---
 drivers/nfc/s3fwrn5/i2c.c                        |  5 ++---
 drivers/nfc/st-nci/i2c.c                         |  5 ++---
 drivers/nfc/st21nfca/i2c.c                       |  5 ++---
 drivers/of/unittest.c                            | 10 ++++------
 drivers/pinctrl/pinctrl-mcp23s08_i2c.c           |  5 +++--
 drivers/pinctrl/pinctrl-sx150x.c                 |  6 +++---
 drivers/platform/chrome/cros_ec_i2c.c            |  5 ++---
 drivers/power/supply/adp5061.c                   |  5 ++---
 drivers/power/supply/bq2415x_charger.c           |  6 +++---
 drivers/power/supply/bq24190_charger.c           |  6 +++---
 drivers/power/supply/bq24257_charger.c           |  6 +++---
 drivers/power/supply/bq24735-charger.c           |  5 ++---
 drivers/power/supply/bq2515x_charger.c           |  6 +++---
 drivers/power/supply/bq256xx_charger.c           |  6 +++---
 drivers/power/supply/bq25890_charger.c           |  5 ++---
 drivers/power/supply/bq25980_charger.c           |  6 +++---
 drivers/power/supply/bq27xxx_battery_i2c.c       |  6 +++---
 drivers/power/supply/ds2782_battery.c            |  6 +++---
 drivers/power/supply/lp8727_charger.c            |  4 ++--
 drivers/power/supply/ltc2941-battery-gauge.c     |  5 ++---
 drivers/power/supply/ltc4162-l-charger.c         |  5 ++---
 drivers/power/supply/max14656_charger_detector.c |  5 ++---
 drivers/power/supply/max17040_battery.c          |  6 +++---
 drivers/power/supply/max17042_battery.c          |  6 +++---
 drivers/power/supply/rt5033_battery.c            |  5 ++---
 drivers/power/supply/rt9455_charger.c            |  5 ++---
 drivers/power/supply/sbs-charger.c               |  5 ++---
 drivers/power/supply/sbs-manager.c               |  6 +++---
 drivers/power/supply/smb347-charger.c            |  6 +++---
 drivers/power/supply/ucs1002_power.c             |  5 ++---
 drivers/power/supply/z2_battery.c                |  5 ++---
 drivers/pwm/pwm-pca9685.c                        |  5 ++---
 drivers/regulator/act8865-regulator.c            |  6 +++---
 drivers/regulator/ad5398.c                       |  6 +++---
 drivers/regulator/da9121-regulator.c             |  5 ++---
 drivers/regulator/fan53555.c                     |  6 +++---
 drivers/regulator/isl6271a-regulator.c           |  6 +++---
 drivers/regulator/lp3972.c                       |  5 ++---
 drivers/regulator/lp872x.c                       |  5 +++--
 drivers/regulator/lp8755.c                       |  5 ++---
 drivers/regulator/ltc3589.c                      |  6 +++---
 drivers/regulator/max1586.c                      |  5 ++---
 drivers/regulator/max8649.c                      |  5 ++---
 drivers/regulator/max8660.c                      |  6 +++---
 drivers/regulator/max8952.c                      |  5 ++---
 drivers/regulator/max8973-regulator.c            |  6 +++---
 drivers/regulator/pca9450-regulator.c            |  5 ++---
 drivers/regulator/pfuze100-regulator.c           |  6 +++---
 drivers/regulator/pv88080-regulator.c            |  6 +++---
 drivers/regulator/rpi-panel-attiny-regulator.c   |  5 ++---
 drivers/regulator/tps51632-regulator.c           |  5 ++---
 drivers/regulator/tps62360-regulator.c           |  6 +++---
 drivers/regulator/tps6286x-regulator.c           |  5 ++---
 drivers/regulator/tps65023-regulator.c           |  6 +++---
 drivers/rtc/rtc-ds1307.c                         |  6 +++---
 drivers/rtc/rtc-isl1208.c                        |  1 +
 drivers/rtc/rtc-m41t80.c                         |  1 +
 drivers/rtc/rtc-rs5c372.c                        |  1 +
 drivers/spi/spi-sc18is602.c                      |  6 +++---
 drivers/spi/spi-xcomm.c                          |  5 ++---
 drivers/staging/iio/addac/adt7316-i2c.c          |  6 +++---
 drivers/staging/iio/impedance-analyzer/ad5933.c  |  6 +++---
 drivers/staging/iio/meter/ade7854-i2c.c          |  5 ++---
 drivers/staging/most/i2c/i2c.c                   |  4 ++--
 drivers/staging/olpc_dcon/olpc_dcon.c            |  4 ++--
 drivers/tty/serial/sc16is7xx.c                   |  6 +++---
 drivers/usb/misc/usb251xb.c                      |  5 ++---
 drivers/usb/misc/usb3503.c                       |  5 ++---
 drivers/usb/misc/usb4604.c                       |  5 ++---
 drivers/usb/phy/phy-isp1301-omap.c               |  4 ++--
 drivers/usb/phy/phy-isp1301.c                    |  5 ++---
 drivers/usb/typec/anx7411.c                      |  5 ++---
 drivers/usb/typec/hd3ss3220.c                    |  5 ++---
 drivers/usb/typec/tcpm/fusb302.c                 |  5 ++---
 drivers/usb/typec/tcpm/tcpci.c                   |  5 ++---
 drivers/usb/typec/tcpm/tcpci_maxim.c             |  4 ++--
 drivers/usb/typec/tcpm/tcpci_rt1711h.c           |  5 ++---
 drivers/usb/typec/ucsi/ucsi_ccg.c                |  5 ++---
 drivers/usb/typec/ucsi/ucsi_stm32g0.c            |  4 ++--
 drivers/video/backlight/adp8860_bl.c             |  6 +++---
 drivers/video/backlight/adp8870_bl.c             |  6 +++---
 drivers/video/backlight/arcxcnn_bl.c             |  4 ++--
 drivers/video/backlight/bd6107.c                 |  5 ++---
 drivers/video/backlight/lm3630a_bl.c             |  5 ++---
 drivers/video/backlight/lm3639_bl.c              |  5 ++---
 drivers/video/backlight/lp855x_bl.c              |  5 +++--
 drivers/video/backlight/lv5207lp.c               |  5 ++---
 drivers/video/backlight/tosa_bl.c                |  5 ++---
 drivers/video/fbdev/matrox/matroxfb_maven.c      |  5 ++---
 drivers/w1/masters/ds2482.c                      |  5 ++---
 drivers/watchdog/ziirave_wdt.c                   |  5 ++---
 include/linux/i2c.h                              | 12 +++++++-----
 sound/aoa/codecs/onyx.c                          |  5 ++---
 sound/aoa/codecs/tas.c                           |  5 ++---
 sound/pci/hda/cs35l41_hda_i2c.c                  |  4 ++--
 sound/ppc/keywest.c                              |  5 ++---
 sound/soc/codecs/es8326.c                        |  5 ++---
 sound/soc/codecs/max98396.c                      |  6 +++---
 sound/soc/codecs/src4xxx-i2c.c                   |  5 ++---
 sound/soc/codecs/tas2780.c                       |  5 ++---
 607 files changed, 1429 insertions(+), 1790 deletions(-)


base-commit: 147307c69ba4441ee90c1f8ce8edf5df4ea60f67
-- 
2.38.1

