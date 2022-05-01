Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A60516401
	for <lists+netdev@lfdr.de>; Sun,  1 May 2022 13:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345540AbiEALWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 May 2022 07:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345385AbiEALWJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 May 2022 07:22:09 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491C35838B
        for <netdev@vger.kernel.org>; Sun,  1 May 2022 04:18:44 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id g6so23204191ejw.1
        for <netdev@vger.kernel.org>; Sun, 01 May 2022 04:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kmOXxqR2gjwWuxJMD9/mtb1euHJrYGAeoYRpFFuxo+Y=;
        b=FuZeLccs88y6zYcnhF7fzr43MM8zJJKT4ItmgEaW3vDMLBHNrjCKWUwWI0rKWfK0cm
         KuZX9luhziXQ4K+XYVqKNdvkbgsm3gbNMEu234D+WJz4a1ufv168r4y5+6sEGcdncjYW
         1GNMh8eFo38g4L+fgP43oaoWkR+zlY1vg7g481351J8zs6VxEF3GuHethcD41U+D/DNA
         /XwzG3FYlfq/gvXChBPS+STIkGCsjQ36Fh3GCeaXgGWElh5NCh/VDSBwBEY0krnj25KZ
         2kXgZgurEaMWRiChg+erixm9oO+n932JgAfWA/n3TL+txzn+01cf38JmMgrkBWW4cOiC
         KtIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kmOXxqR2gjwWuxJMD9/mtb1euHJrYGAeoYRpFFuxo+Y=;
        b=jL/cbsEIU/xlPK/CI9h4T5HIm6IaMkpIW1r3G5EvBBSbRF7uMZy2UrNWxvIKs0np/Q
         dZK94/iMCox9ZsPvaW4B8G0XuR87JFJVjd45J0Us3XB4avDRwooNxYvW3W19pvpYf6tb
         xN0XqlkKNB6yqRwHW2rN095tjcZng4cirv6K/qySHxxNlXXaVphzYJJ6Ot+Hiy5WWjDz
         6F2bNIjVTv7HDh4npLoqlQGQy/hGU3pGNaUnvXNf0uI7PKE7ZDtoH2WfHwziSj0t9cfp
         H/VIzfq+86KpNstK6t4u4YjL7XWKf/4qEb51RUxcOmE/4SqOLiN+vXUSMOwIzzdwMeIa
         6OXQ==
X-Gm-Message-State: AOAM530nd+Ul40ceCi/bCMR+yB+jQjEMKLA3zYuY0sCjQx1EWPFYhXf6
        eWB7b/ogfraUHhzq+WQ3hXLq+A==
X-Google-Smtp-Source: ABdhPJys2SxHLa73MPknrtokfFDNDHUVhVXv62Q0NS9VNrs154RzgfBDZmSIkzQGoo05q24I/OAPAw==
X-Received: by 2002:a17:906:3042:b0:6cd:20ed:7c5c with SMTP id d2-20020a170906304200b006cd20ed7c5cmr6977150ejd.241.1651403922837;
        Sun, 01 May 2022 04:18:42 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:8366:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id mm29-20020a170906cc5d00b006f3ef214dcesm2508630ejb.52.2022.05.01.04.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 04:18:42 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     mlichvar@redhat.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v3 0/6] ptp: Support hardware clocks with additional free running cycle counter
Date:   Sun,  1 May 2022 13:18:30 +0200
Message-Id: <20220501111836.10910-1-gerhard@engleder-embedded.com>
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

v3:
- optimize ptp_convert_timestamp (Richard Cochran)
- call dev_get_by_napi_id() only if needed (Richard Cochran)
- use non-negated logical test (Richard Cochran)
- add comment for skipped output (Richard Cochran)
- add comment for SKBTX_HW_TSTAMP_USE_CYCLES masking (Richard Cochran)

v2:
- rename ptp_clock cycles to has_cycles (Richard Cochran)
- call it free running cycle counter (Richard Cochran)
- update struct skb_shared_hwtstamps kdoc (Richard Cochran)
- optimize timestamp address/cookie processing path (Richard Cochran,
  Vinicius Costa Gomes)

v1:
- complete rework based on suggestions (Richard Cochran)

Gerhard Engleder (6):
  ptp: Add cycles support for virtual clocks
  ptp: Request cycles for TX timestamp
  ptp: Pass hwtstamp to ptp_convert_timestamp()
  ptp: Support late timestamp determination
  ptp: Speed up vclock lookup
  tsnep: Add free running cycle counter support

 drivers/net/ethernet/engleder/tsnep_hw.h   |  9 ++-
 drivers/net/ethernet/engleder/tsnep_main.c | 33 +++++++--
 drivers/net/ethernet/engleder/tsnep_ptp.c  | 28 ++++++++
 drivers/ptp/ptp_clock.c                    | 31 ++++++--
 drivers/ptp/ptp_private.h                  | 11 +++
 drivers/ptp/ptp_sysfs.c                    | 11 +--
 drivers/ptp/ptp_vclock.c                   | 82 ++++++++++++++--------
 include/linux/netdevice.h                  | 21 ++++++
 include/linux/ptp_clock_kernel.h           | 38 ++++++++--
 include/linux/skbuff.h                     | 21 +++++-
 net/core/skbuff.c                          |  5 ++
 net/socket.c                               | 53 +++++++++++---
 12 files changed, 281 insertions(+), 62 deletions(-)

-- 
2.20.1

