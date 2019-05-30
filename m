Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFFE130454
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 23:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfE3V4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 17:56:35 -0400
Received: from mail-it1-f174.google.com ([209.85.166.174]:32886 "EHLO
        mail-it1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbfE3V4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 17:56:35 -0400
Received: by mail-it1-f174.google.com with SMTP id j17so9262836itk.0
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 14:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=MhJz/1UwyHbWUoknAE0o4TRG5L0JDlOm2mEcnXU7Js0=;
        b=tGxSWJ0VRh21atJSSlg819/I67rrPL3U8oDpYUSfr8qd3vD9UjT86aC37wLUlkaRRS
         1faYGwIob9pTYfDkZq0iXD7QUyuf+dNxI5+0IhUKTzR4Q6X/NZE/x3HQnEG2DCOq7K5m
         TFCg/bIyjqsTeqCpYRzLHtUyI9Q4TEstnP/W29amL4xE1tPTW6EUVRK7FdxAdftB1CJ2
         D/LX/NshHTKbhRa+sxVbUHpYlIAmkaj1xIzWtEEu+nTlyz0VbZwBzSRRiQCHu4/asJ1d
         yMCiB8mBXer3jqmBXkcWV6Idr2+96vYaPbP3KouIvdvOhM5R/8jsSld1zOOJ+bKeMPvQ
         UUpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=MhJz/1UwyHbWUoknAE0o4TRG5L0JDlOm2mEcnXU7Js0=;
        b=T2epVSwDcK5SQzvPkYSntSBJKPRTFa7e7LY9pOgCxZYRqjkLiTjpnY74S/MpVrm23G
         DsQYeEWWJ24yBzGtJzMVvYe9NXLqeASZRS05JKDKuPUJTPZfzE3GquALzy+8JbHfNbSl
         SNMuMDpCFhYVpUnVdJ+TJCbiq3TW296OhC7UJtilyYKFaFIYxSWe1O0WqC53fmrc5j6/
         QRHCKuojUHqnkO1f4DkQTwAp+XGaFJzvYmQ5Lmt5kw8uNl7fIC+LzSuxhSLHYqiLRJs6
         O+qZuw9ys2fYcBLfFgb2MI4B7+9WpvH0Sr3d3ugu+ejwoW816q2bKT+gNC9EfAZ83r47
         Fe0w==
X-Gm-Message-State: APjAAAVbmXvg3Pfv85o4JOHzmHSgvCtH90RgRg4JkTRI/8vOS0LbJhZt
        Qs/xos1C5PkvsU8Cb6tQTRdrcg==
X-Google-Smtp-Source: APXvYqz9Jku3ffdu+qdNkeouc0IZHFLCbvvVj0a00LXSniVzMmRZEx+UxyMhkHh+Y2qHLwbx8C077A==
X-Received: by 2002:a24:9ac7:: with SMTP id l190mr3642301ite.100.1559253042262;
        Thu, 30 May 2019 14:50:42 -0700 (PDT)
Received: from localhost.localdomain (107-0-94-194-ip-static.hfc.comcastbusiness.net. [107.0.94.194])
        by smtp.gmail.com with ESMTPSA id j125sm1662391itb.27.2019.05.30.14.50.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 30 May 2019 14:50:41 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [PATCH net-next 0/6] seg6: Segment routing fixes
Date:   Thu, 30 May 2019 14:50:15 -0700
Message-Id: <1559253021-16772-1-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A few bug fixes, code clean up, and minor enhancements to segment
routing.

Changes include:
  - Fix SRH TLV definitions
  - Implement a TLV parsing loop
  - Eliminate the HMAC flag
  - Support to rearrange segment routing header for AH ICV
    calculation

Tom Herbert (6):
  seg6: Fix TLV definitions
  seg6: Implement a TLV parsing loop
  seg6: Remove HMAC flag and implement seg6_find_hmac_tlv
  ah6: Create function __zero_out_mutable_opts
  ah6: Be explicit about which routing types are processed.
  seg6: Add support to rearrange SRH for AH ICV calculation

 include/net/seg6.h        | 16 +++++++++
 include/uapi/linux/seg6.h |  9 ++---
 net/ipv6/ah6.c            | 90 +++++++++++++++++++++++++++++++++++------------
 net/ipv6/exthdrs.c        |  2 +-
 net/ipv6/seg6.c           | 68 +++++++++++++++++++++--------------
 net/ipv6/seg6_hmac.c      |  8 ++---
 net/ipv6/seg6_iptunnel.c  |  4 +--
 7 files changed, 134 insertions(+), 63 deletions(-)

-- 
2.7.4

