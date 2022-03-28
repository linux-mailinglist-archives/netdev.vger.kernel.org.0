Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BDA14E9EA9
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 20:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244934AbiC1SEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 14:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245147AbiC1SDX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 14:03:23 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D3844839F
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:01:42 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id bn33so20316986ljb.6
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 11:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uuYv067X4kT+NOzbPXQ219scQGqPB4cAH5gxcRBn5ME=;
        b=RyjbhIYZZ7QEgJfc3+9Bvvfbd8rZqEPj/OObh6rKDftThCHs1swjSvwR2LsVN2SMXn
         ACeJlGqAX0jZU6F0xlnzpYw7hbagCAR/zZLV+JNklkWGwSwvEW1KcmO7l78PUUW1OZgs
         wLtAHxeU1GiXwYZ5dlr2HBceQA4EVjrnVyjsofmW1YxlcOPqS8S+n+0/Cybudrx+USc7
         rYeomXkg6+VSjJSzSesLobXvpvMInAmwMTitRxEfPaI0eQ/8COOsr21qosO8ck+XJ7zq
         UJEaVw4GqdoS/oHfy7t42zHNWpI34jr4HGSu20CZOZJk3tulDkJdnNzdjdbaxmRyiwFS
         UPWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uuYv067X4kT+NOzbPXQ219scQGqPB4cAH5gxcRBn5ME=;
        b=k10MqRw7yh2PONC6cTeoldngbxofhEz6n9nYUlW7pN4/1K1WCRxWjyk/pG7cwELo2c
         v3NHIv5x5YE9vI+DqAJyB77wh+lFpgs9U4E7dbojGZ55tapX6NuLj5vIWiSbeEy4Pxy9
         IuGVWP8Febowp6BwvOd9unSbcDOSh12vkahVqtVvA22+WLoIHUPqgiFS7Tt+wmFNO5lL
         iei/GYXkNsa35QPXZ2KcAdjNf3BC3HJvvHfyJ7GHlQPzzM7jvX55WIYbefbdNwvBpsHQ
         GDTX5FAQyq4SK2Lv0xlGbFsFOqJF1InTIbQ/xCOWiV3f4VAXURAkgONGuvgMsszSiaCt
         eDqQ==
X-Gm-Message-State: AOAM533mIGxtY/wXTYDsJZGE/EL/J1PjBuBlx6QhWzyaZZp5NFYtnbMS
        8XiziQPahv4dbE05KaaC2XRixSXmSEbzh8a/
X-Google-Smtp-Source: ABdhPJyshjbv5zxOBh3CePhb4vs8HHNCKWvlGyNfSZ0PMMK0RCvdxXijXOCiAixCaIl0voXdnRAxrA==
X-Received: by 2002:a05:651c:17a3:b0:245:f39e:f2d2 with SMTP id bn35-20020a05651c17a300b00245f39ef2d2mr22295503ljb.490.1648490500316;
        Mon, 28 Mar 2022 11:01:40 -0700 (PDT)
Received: from localhost.localdomain (host-188-190-49-235.la.net.ua. [188.190.49.235])
        by smtp.gmail.com with ESMTPSA id a4-20020a2eb164000000b0024988e1cfb6sm1801559ljm.94.2022.03.28.11.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 11:01:39 -0700 (PDT)
From:   Andrew Melnychenko <andrew@daynix.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     kuba@kernel.org, davem@davemloft.net, jasowang@redhat.com,
        mst@redhat.com, yan@daynix.com, yuri.benditovich@daynix.com
Subject: [PATCH v5 0/4] RSS support for VirtioNet.
Date:   Mon, 28 Mar 2022 20:53:32 +0300
Message-Id: <20220328175336.10802-1-andrew@daynix.com>
X-Mailer: git-send-email 2.35.1
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

Virtio-net supports "hardware" RSS with toeplitz key.
Also, it allows receiving calculated hash in vheader
that may be used with RPS.
Added ethtools callbacks to manipulate RSS.

Technically hash calculation may be set only for
SRC+DST and SRC+DST+PORTSRC+PORTDST hashflows.
The completely disabling hash calculation for TCP or UDP
would disable hash calculation for IP.

RSS/RXHASH is disabled by default.

Changes since v4:
* Refactored code.
* Fixed sparse warnings, there would be warnings for using
  restricted fields in vnet header structure.

Changes since v3:
* Moved hunks a bit.
* Added indirection table zero size check
  for hash report only feature.
* Added virtio_skb_set_hash() helper instead of in-place routine.

Changes since v2:
* Fixed issue with calculating padded header length.
  During review/tests, there was found an issue that
  will crash the kernel if VIRTIO_NET_F_MRG_RXBUF
  was not set. (thx to Jason Wang <jasowang@redhat.com>)
* Refactored the code according to review.

Changes since v1:
* Refactored virtnet_set_hashflow.
* Refactored virtio_net_ctrl_rss.
* Moved hunks between patches a bit.

Changes since rfc:
* Code refactored.
* Patches reformatted.
* Added feature validation.

Andrew (1):
  drivers/net/virtio_net: Added RSS hash report control.

Andrew Melnychenko (3):
  drivers/net/virtio_net: Fixed padded vheader to use v1 with hash.
  drivers/net/virtio_net: Added basic RSS support.
  drivers/net/virtio_net: Added RSS hash report.

 drivers/net/virtio_net.c | 389 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 376 insertions(+), 13 deletions(-)

-- 
2.35.1

