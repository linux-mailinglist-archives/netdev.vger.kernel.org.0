Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36901665C2F
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbjAKNNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 08:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbjAKNNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:13:07 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03A565FC8
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:13:06 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id j16-20020a05600c1c1000b003d9ef8c274bso8241098wms.0
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UDBLqSVgjhmUUpWLcXQemRrGD2PxfpbWckErOtG2MXU=;
        b=Hc8QHEdXxDo0AS/WWb9sSN4594j17V0w404Q0nRPj7Sgtmq1gBFx0AafjAB6IEnqmB
         V6A4M1sElD0C9Yh4cNRi0QY7kP81EYEZU0cbU7OFVkd2wf5ysPuMJeqKKpUqDbRRXJOE
         YkR67/dDEcfN4i8cBPiKpfi30TC7aL53dj3lugW8XF9Sot+z1iyvZW8Br3DqjDXMJDMP
         mupFdyaWQjjrmJN/bhMxlP706SzMIzdgBs1cskzVhG0z2WzxgdAnp77QORkNRZLul9z1
         l+0Ewzv25Qq3lnGPvlEn01tTGzeqUi7KiEBKO2kGiBmknMcXEKqDa/ilmRC0r6bQpl3Z
         g4FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UDBLqSVgjhmUUpWLcXQemRrGD2PxfpbWckErOtG2MXU=;
        b=D1CKwAEjZ3QTuRSn2W2n6pCQ8Ql4Iqkv8AtY0ebQBuEHGN7pcG+M9JnRU0xuV3ObE5
         fHEWUDnH55pgIhR4w/TYeX2p7sd3ZRlEwtG4c7VuNaSxmZPPZdXDUSeKdCFKXoi2QvK9
         FUOBZ9qcHT80L1oQlTTWV3wWAgpoEbdQMrIO/h8q7D2gIVTzTi7rd5mPf0YG6aCdlDIk
         jn5zh3rfPvKwGhXquGgdNTLKm0UvLShf/lC+XXAY7U1W04PgROyir2uWpidIL+nnihmM
         1EtiyhnsQdGBVwm3whp5pK+raDtSJfEQEKVz1C29GlM+qY4hWSyHmYfwL575f/77k/j6
         0EVA==
X-Gm-Message-State: AFqh2krr1pFOgmu7dgst/zU6NxeiDx5H+J+rQaWrViDIDk4I7CkK/vh7
        s3Dm7tv/AcAuYIOj6yJKxdE=
X-Google-Smtp-Source: AMrXdXu6ddVowZ1xNh7BVGVf2koVmoVk8pVgOebyvXdnh0nDxhZjwLZoicS7AB1wx/b4K7tp5sOzag==
X-Received: by 2002:a05:600c:539a:b0:3d9:efe8:a42d with SMTP id hg26-20020a05600c539a00b003d9efe8a42dmr8443612wmb.21.1673442784322;
        Wed, 11 Jan 2023 05:13:04 -0800 (PST)
Received: from ThinkStation-P340.tmt.telital.com ([2a01:7d0:4800:7:4ce:b9aa:c77:7d5e])
        by smtp.gmail.com with ESMTPSA id m7-20020a05600c3b0700b003cfd4cf0761sm25796521wms.1.2023.01.11.05.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 05:13:03 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Gal Pressman <gal@nvidia.com>, Dave Taht <dave.taht@gmail.com>
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH net-next v4 0/3] add tx packets aggregation to ethtool and rmnet
Date:   Wed, 11 Jan 2023 14:05:17 +0100
Message-Id: <20230111130520.483222-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,HK_RANDOM_ENVFROM,
        HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello maintainers and all,

this patchset implements tx qmap packets aggregation in rmnet and generic
ethtool support for that.

Some low-cat Thread-x based modems are not capable of properly reaching the maximum
allowed throughput both in tx and rx during a bidirectional test if tx packets
aggregation is not enabled.

I verified this problem with rmnet + qmi_wwan by using a MDM9207 Cat. 4 based modem
(50Mbps/150Mbps max throughput). What is actually happening is pictured at
https://drive.google.com/file/d/1gSbozrtd9h0X63i6vdkNpN68d-9sg8f9/view

Testing with iperf TCP, when rx and tx flows are tested singularly there's no issue
in tx and minor issues in rx (not able to reach max throughput). When there are concurrent
tx and rx flows, tx throughput has an huge drop. rx a minor one, but still present.

The same scenario with tx aggregation enabled is pictured at
https://drive.google.com/file/d/1jcVIKNZD7K3lHtwKE5W02mpaloudYYih/view
showing a regular graph.

This issue does not happen with high-cat modems (e.g. SDX20), or at least it
does not happen at the throughputs I'm able to test currently: maybe the same
could happen when moving close to the maximum rates supported by those modems.
Anyway, having the tx aggregation enabled should not hurt.

The first attempt to solve this issue was in qmi_wwan qmap implementation,
see the discussion at https://lore.kernel.org/netdev/20221019132503.6783-1-dnlplm@gmail.com/

However, it turned out that rmnet was a better candidate for the implementation.

Moreover, Greg and Jakub suggested also to use ethtool for the configuration:
not sure if I got their advice right, but this patchset add also generic ethtool
support for tx aggregation.

The patches have been tested mainly against an MDM9207 based modem through USB
and SDX55 through PCI (MHI).

v2 should address the comments highlighted in the review: the implementation is
still in rmnet, due to Subash's request of keeping tx aggregation there.

v3 fixes ethtool-netlink.rst content out of table bounds and a W=1 build warning
for patch 2.

v4 solves a race related to egress_agg_params.

Daniele Palmas (3):
  ethtool: add tx aggregation parameters
  net: qualcomm: rmnet: add tx packets aggregation
  net: qualcomm: rmnet: add ethtool support for configuring tx
    aggregation

 Documentation/networking/ethtool-netlink.rst  |  17 ++
 .../ethernet/qualcomm/rmnet/rmnet_config.c    |   5 +
 .../ethernet/qualcomm/rmnet/rmnet_config.h    |  20 ++
 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  18 +-
 .../net/ethernet/qualcomm/rmnet/rmnet_map.h   |   6 +
 .../ethernet/qualcomm/rmnet/rmnet_map_data.c  | 191 ++++++++++++++++++
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.c   |  54 ++++-
 .../net/ethernet/qualcomm/rmnet/rmnet_vnd.h   |   1 +
 include/linux/ethtool.h                       |  12 +-
 include/uapi/linux/ethtool_netlink.h          |   3 +
 net/ethtool/coalesce.c                        |  22 +-
 11 files changed, 342 insertions(+), 7 deletions(-)

-- 
2.37.1

