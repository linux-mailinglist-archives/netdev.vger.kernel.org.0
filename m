Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6C551DFE2
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 22:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392440AbiEFUFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 16:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377267AbiEFUFn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 16:05:43 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BCA24F37
        for <netdev@vger.kernel.org>; Fri,  6 May 2022 13:01:58 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id z2so14797695ejj.3
        for <netdev@vger.kernel.org>; Fri, 06 May 2022 13:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=engleder-embedded-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=inzyKNOj/FjjewZShVuqB99mugylLYFBYq5omPwXL5A=;
        b=ygccpZxEEni7/MM8b+sY/CUaTmsKm1+4d/vqaB+WhRvTeBpDaJvEfGxwHG0dLIeNTw
         HhNIT0UshY3D+CqmrJmN3oCdQ7K3rEK54gSVXwb1GvpIrm9fwxZSwVDey6nHmIMq+spv
         GyKxNbrp7ZHAiPa7Q1gZ5Sk3/is4rlwJMNNiPjt/j09tkCvIljZCsGZxUhIwbau+taD4
         E1YTM6IJI51wugi6OLTIXiCX+y4S0tkNTDCfA3CUXqZ2bArm24ttIOOEQFwk3/Ygfhrm
         5+Zxgsk6hWUB6yiuycPKr6h8Q+TMqjcN+2eMcVlF7TcZGuvPldA09voa4sll6n3dIs7p
         j6ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=inzyKNOj/FjjewZShVuqB99mugylLYFBYq5omPwXL5A=;
        b=Jpt1yImJr8uw7mrTP86D/miJMeuilrTYtQsg9yBD0J4bYtF00iD0UMFI4Oao27LAzf
         VzwvxA5+KKX35ZFD0JIOtHtQeBfISTgGwd7cnU8rx4sQr0tTmlFGp1oXliWtlPG1hx1m
         uWnP3AnWzUXjojHeY3Lj3XJq5UOS5ai947eB1iY8SeUUlsq01IB5KULcJuxhZdzMh9MW
         PGT2yRQQp1mOZZVwlNRj7XvP4eFjW9lUDxrs425Y0wcX6FFmIcNWzKwZ8V8SoaEScYcT
         q3Y5qEIKQXmNhwuvqIN1lDpYqlH7xn2jy/LaJwcy9964z/BhY34o7QyrfORs5NhhHnmk
         9uIg==
X-Gm-Message-State: AOAM530zKkHkE7JRLKxSyMEmSrfbOq6OEdV/xqBNDtGd6Rpc7plyLYzw
        o3Ce/TuvBd589xzrbra6rHBRuQ==
X-Google-Smtp-Source: ABdhPJy+DmRyCp99PpRVy/GnNr+fHbGvLFwIBN5ilD8Dhi4EAecf7geOaJ1KPddSv5hYrqdmQzIyQg==
X-Received: by 2002:a17:907:a40d:b0:6f5:1611:c55e with SMTP id sg13-20020a170907a40d00b006f51611c55emr4520542ejc.479.1651867317321;
        Fri, 06 May 2022 13:01:57 -0700 (PDT)
Received: from hornet.engleder.at ([2001:871:23a:237:6e3b:e5ff:fe2c:34c1])
        by smtp.gmail.com with ESMTPSA id w5-20020a056402268500b0042617ba6389sm2719887edd.19.2022.05.06.13.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 13:01:56 -0700 (PDT)
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     richardcochran@gmail.com, vinicius.gomes@intel.com,
        yangbo.lu@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     mlichvar@redhat.com, willemb@google.com, kafai@fb.com,
        jonathan.lemon@gmail.com, netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next v4 0/6] ptp: Support hardware clocks with additional free running cycle counter
Date:   Fri,  6 May 2022 22:01:36 +0200
Message-Id: <20220506200142.3329-1-gerhard@engleder-embedded.com>
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

v4:
- if_index of 0 is invalid (Jonathan Lemon)
- set if_index to 0 in the SOF_TIMESTAMPING_RAW_HARDWARE block (Jonathan
  Lemon)
- add helper function for netdev_get_tstamp() call (Jonathan Lemon)
- update SKBTX_ANY_TSTAMP (Paolo Abeni)
- use separate bits for new tx_flags (Richard Cochran)

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
 include/linux/skbuff.h                     | 21 ++++--
 net/socket.c                               | 60 +++++++++++++---
 11 files changed, 282 insertions(+), 63 deletions(-)

-- 
2.20.1

