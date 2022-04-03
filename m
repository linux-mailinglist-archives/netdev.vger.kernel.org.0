Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4174F0BA9
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 19:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359717AbiDCR6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 13:58:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232386AbiDCR5x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 13:57:53 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D50E387BF
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 10:55:57 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id bh17so15593999ejb.8
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 10:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ac99P01r4VAiykJjLQulCjck9r03E/LoZkypaKCjR60=;
        b=WVyFw9sbilnCjRVX9LgS0yVb4nqnR6bcrSdI02QSx4THWbrULAUfitB//23THqlcc9
         e9Y570lGxR12prOm4FkySV9fTt5YpPgKig5/57OR3JjaJBCxaV8Z4m4QWtwjtVe/LBWl
         SBX7ArhP5Jb2hZckkIsmmrEBmBOIS4gt8zKX8TIGeWeWid4/lgitM8/Mop1qdGMTFRrA
         RPvoGEgIpdpabvrF6SGpTmo/cPjKC3IHo7CaFpsxnGz3BNBwajsGUMFJeY8Ls449t7XT
         PXGA9doxqbRjPNrvtR0dusu6AHVM9lXzm8Zx4NHA+VjrTkn5kssGv3S0hhQgZWjAfIBs
         H2hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ac99P01r4VAiykJjLQulCjck9r03E/LoZkypaKCjR60=;
        b=z2htEbFhPDsUEHNFUieY6lG0OQQQGVZ7gvVI93K0NmRM5rxTba8b4DK5dwcs6Jte6N
         6dWkR1FyPJLmSrYj9bU6n+/aHyLd7TqWG0Qzwxyn5Hw9Z1tbHKyVxuKFUFsI186764AX
         E2xGv4/QDSuWcoN2V+yYMpPTMuNZQLMtmGq9di5AFpAupJF6fc+44BBSu4rW8S/HivZI
         DJEkKQTR7TfvBjozs3KDFlg+dJpNnBJpdwiDl7eJSJ4zlB6Ej9hVzh4Ictn5jICO3YCB
         H5jSIzahEdzSwVzPYUNWwzS7q1XPZyDS2MwWEjJKPnOObt2R2JxGBryR369hg89mfg2G
         9Dhw==
X-Gm-Message-State: AOAM530tjJr5NjLf8rZqz78kmV0NN5fPP23GRKUAadrXQQDLeK49U9zG
        x4xeL8TZDrNWcNisqrwXQHtFoDfIyIaGYZlT
X-Google-Smtp-Source: ABdhPJwjE128796TWmQtx0I5iQ1ZmNLBu92uZsnth9yjbhmNJbtnzTLjVwWdSWX0g4n7MKsb4sXDuQ==
X-Received: by 2002:a17:907:3f91:b0:6d7:16c0:ae1b with SMTP id hr17-20020a1709073f9100b006d716c0ae1bmr7761259ejc.74.1649008555900;
        Sun, 03 Apr 2022 10:55:55 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id q7-20020a170906540700b006d5eca5c9cfsm3451065ejo.191.2022.04.03.10.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 10:55:55 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     mlichvar@redhat.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v2 0/5] ptp: Support hardware clocks with additional free running cycle counter
Date:   Sun,  3 Apr 2022 19:55:39 +0200
Message-Id: <20220403175544.26556-1-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ptp vclocks require a clock with free running time for the timecounter.
Currently only a physical clock forced to free running is supported.
If vclocks are used, then the physical clock cannot be synchronized
anymore. The synchronized time is not available in hardware in this
case. As a result, timed transmission with TAPRIO hardware support
is not possible anymore.

If hardware would support a free running time additionally to the
physical clock, then the physical clock does not need to be forced to
free running. Thus, the physical clocks can still be synchronized while
vclocks are in use.

The physical clock could be used to synchronize the time domain of the
TSN network and trigger TAPRIO. In parallel vclocks can be used to
synchronize other time domains.

One year ago I thought for two time domains within a TSN network also
two physical clocks are required. This would lead to new kernel
interfaces for asking for the second clock, ... . But actually for a
time triggered system like TSN there can be only one time domain that
controls the system itself. All other time domains belong to other
layers, but not to the time triggered system itself. So other time
domains can be based on a free running counter if similar mechanisms
like 2 step synchroisation are used.

Synchronisation was tested with two time domains between two directly
connected hosts. Each host run two ptp4l instances, the first used the
physical clock and the second used the virtual clock. I used my FPGA
based network controller as network device. ptp4l was used in
combination with the virtual clock support patches from Miroslav
Lichvar.

v2:
- rename ptp_clock cycles to has_cycles (Richard Cochran)
- call it free running cycle counter (Richard Cochran)
- update struct skb_shared_hwtstamps kdoc (Richard Cochran)
- optimize timestamp address/cookie processing path (Richard Cochran,
  Vinicius Costa Gomes)

v1:
- complete rework based on suggestions (Richard Cochran)

Gerhard Engleder (5):
  ptp: Add cycles support for virtual clocks
  ptp: Request cycles for TX timestamp
  ptp: Pass hwtstamp to ptp_convert_timestamp()
  ptp: Support late timestamp determination
  tsnep: Add free running cycle counter support

 drivers/net/ethernet/engleder/tsnep_hw.h   |  9 +++--
 drivers/net/ethernet/engleder/tsnep_main.c | 31 +++++++++++++---
 drivers/net/ethernet/engleder/tsnep_ptp.c  | 28 +++++++++++++++
 drivers/ptp/ptp_clock.c                    | 31 +++++++++++++---
 drivers/ptp/ptp_private.h                  | 10 ++++++
 drivers/ptp/ptp_sysfs.c                    | 10 +++---
 drivers/ptp/ptp_vclock.c                   | 18 ++++------
 include/linux/netdevice.h                  | 21 +++++++++++
 include/linux/ptp_clock_kernel.h           | 38 +++++++++++++++++---
 include/linux/skbuff.h                     | 14 ++++++--
 net/core/skbuff.c                          |  2 ++
 net/socket.c                               | 41 +++++++++++++++-------
 12 files changed, 208 insertions(+), 45 deletions(-)

-- 
2.20.1

