Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D438F4FEC6E
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 03:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbiDMBqr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 21:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbiDMBqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 21:46:47 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C30CE527C5;
        Tue, 12 Apr 2022 18:44:27 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id b21so466950ljf.4;
        Tue, 12 Apr 2022 18:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ySiyIpfROIPLrNfxp6ftud+YvGVma3cO1KHhZiW0jOM=;
        b=nSUWqZdSI/kAJg7fzVB/bNESSfXx77XC4BL8V3C4CWbzMgp/9ELT+n4cP+QU7kQzWr
         dWWCxSSIX9rB4owJGKAJvJKGVSv4S8KnTa1xKIRv5RlocHDH+lhmQWx6wcHp0Z7dDjLy
         UxqjocVCeBilJOGf7Dfqui7ITgYYT3GqFrd90njzox2H2pFaPYEcgHlOcn4tBtgduY6q
         JLt5Gamie+R1Dg79U11B42dP3stz6F8YNTSdLnP6kUMbRaWdZ/R3VuPs56hEsxGDGchr
         EEJzT4wxEANHI67qXStsIfIuNqIwoUZ0upome9MyKYgtCHPdm0qe4I3CCFIDtF0FpRQ7
         r4oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ySiyIpfROIPLrNfxp6ftud+YvGVma3cO1KHhZiW0jOM=;
        b=Me+tnykxr2RwYbRUDjPqitjRFWi4lUTz+FMlDTfcPtZA6OFFxR0ny12fPLALf9n7vJ
         2eQHvamj4V3CQPEWhGHDp6IazG26Q0J4iUIPKf9jAzQ+a1wXkXIfAPXFyXxdy3R/2ism
         9yvcEKS70AUi14BB0haylgV8qKojRklWbeC4WvwK4tROA793aZweJoTv9hkabl0vacg9
         GGXNJfCk2TFB4tbPudQQTM10OnWkyhUbQD3+42ysU+K858r9sAR8O+aprANo0/vGAn2g
         XYaQEiY75PQcJfgZLJskfAUCXF797me+GUlS+KTwAOFNpmVv160mrF8SeQgqiNKBoP42
         GUhw==
X-Gm-Message-State: AOAM5323qhCTKDViQRrZaihypv/oyspRUeYDooTiCk319aMSUMKF+ctb
        dtauMtYyBRaLenXrKc2vOY/UwGkRUwKrJg==
X-Google-Smtp-Source: ABdhPJzx+4OqoNSYlqC69DXgtoU/1lrwk9CSja+PwVK+gr3ciqy1EgnHHVTr0JLR8Ban5KIDRBxnwQ==
X-Received: by 2002:a2e:5817:0:b0:24b:50a2:86f0 with SMTP id m23-20020a2e5817000000b0024b50a286f0mr15043837ljb.230.1649814265896;
        Tue, 12 Apr 2022 18:44:25 -0700 (PDT)
Received: from rafiki.local ([2001:470:6180::c8d])
        by smtp.gmail.com with ESMTPSA id u3-20020a197903000000b00464f4c76ebbsm1915574lfc.94.2022.04.12.18.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 18:44:25 -0700 (PDT)
From:   Lech Perczak <lech.perczak@gmail.com>
To:     netdev@vger.kernel.org, linux-usb@vger.kernel.org
Cc:     Lech Perczak <lech.perczak@gmail.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        Oliver Neukum <oliver@neukum.org>
Subject: [PATCH v3 0/3] rndis_host: handle bogus MAC addresses in ZTE RNDIS devices
Date:   Wed, 13 Apr 2022 03:44:13 +0200
Message-Id: <20220413014416.2306843-1-lech.perczak@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When porting support of ZTE MF286R to OpenWrt [1], it was discovered,
that its built-in LTE modem fails to adjust its target MAC address,
when a random MAC address is assigned to the interface, due to detection of
"locally-administered address" bit. This leads to dropping of ingress
trafficat the host. The modem uses RNDIS as its primary interface,
with some variants exposing both of them simultaneously.

Then it was discovered, that cdc_ether driver contains a fixup for that
exact issue, also appearing on CDC ECM interfaces.
I discussed how to proceed with that with Bjørn Mork at OpenWrt forum [3],
with the first approach would be to trust the locally-administered MAC
again, and add a quirk for the problematic ZTE devices, as suggested by
Kristian Evensen. before [4], but reusing the fixup from cdc_ether looks
like a safer and more generic solution.

Finally, according to Bjørn's suggestion. limit the scope of bogus MAC
addressdetection to ZTE devices, the same way as it is done in cdc_ether,
as this trait wasn't really observed outside of ZTE devices.
Do that for both flavours of RNDIS devices, with interface classes
02/02/ff and e0/01/03, as both types are reported by different modems.

[1] https://git.openwrt.org/?p=openwrt/openwrt.git;a=commit;h=7ac8da00609f42b8aba74b7efc6b0d055b7cef3e
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bfe9b9d2df669a57a95d641ed46eb018e204c6ce
[3] https://forum.openwrt.org/t/problem-with-modem-in-zte-mf286r/120988
[4] https://lore.kernel.org/all/CAKfDRXhDp3heiD75Lat7cr1JmY-kaJ-MS0tt7QXX=s8RFjbpUQ@mail.gmail.com/T/

Cc: Bjørn Mork <bjorn@mork.no>
Cc: Kristian Evensen <kristian.evensen@gmail.com>
Cc: Oliver Neukum <oliver@neukum.org>

v3: Fixed wrong identifier commit description and whitespace in patch 2.

v2: ensure that MAC fixup is applied to all Ethernet frames in RNDIS
batch, by introducing a driver flag, and integrating the fixup inside
rndis_rx_fixup().

Lech Perczak (3):
  cdc_ether: export usbnet_cdc_zte_rx_fixup
  rndis_host: enable the bogus MAC fixup for ZTE devices from cdc_ether
  rndis_host: limit scope of bogus MAC address detection to ZTE devices

 drivers/net/usb/cdc_ether.c    |  3 ++-
 drivers/net/usb/rndis_host.c   | 47 +++++++++++++++++++++++++++++++---
 include/linux/usb/rndis_host.h |  1 +
 include/linux/usb/usbnet.h     |  1 +
 4 files changed, 47 insertions(+), 5 deletions(-)

-- 
2.30.2

