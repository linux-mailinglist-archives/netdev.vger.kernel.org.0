Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0871D44E39
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 23:17:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726047AbfFMVRZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 17:17:25 -0400
Received: from mail-qt1-f181.google.com ([209.85.160.181]:40292 "EHLO
        mail-qt1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfFMVRY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 17:17:24 -0400
Received: by mail-qt1-f181.google.com with SMTP id a15so101103qtn.7
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 14:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zYgmybo+c8Qn6p83RotXNWk5iCT3nqmVNkA/ta5FxoY=;
        b=BHcIbG3mwOxs5Q+ODILwa5tbilhwSU2wZILgryJ4+e5NYSOxlfBy4V6SEDbNUcSq7b
         L4cgoiAdd3+9qt2RlJBMpq4Tb/4DTSzncFbd66BaT56XMNnjdQipSTJvgSIw+dPfbWqF
         /rQUSXs5s6ODEeXYoL5ZqOHW2NpxuoApNv/8/AjksfmhUVZLUxx0ojMG8RfOCbMSscc3
         IgQMP0LMuA5FhwPTDuwknMLIrB/8mqmQpofcfRMQVPaoHQhdgaSX/5vRyqJihxdDytiG
         8bYdI97nzuSIK/ypTVDq5TqtVh5ZReIm0NV3q4h4AM1uAEkwGhAbFuX0yYNIx+AgEEZx
         5UoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zYgmybo+c8Qn6p83RotXNWk5iCT3nqmVNkA/ta5FxoY=;
        b=XpbXG/+oU+XB0jxLLFVEcxmDcgSzVCHK8EXcDpEOaZtZ2OrO1r88rl5i4Kijh1XzdR
         h169oX7OlEL0rQsTXN5cnd7FOk3VKlA2dhNVT4PT0QrwpRenyIX6PIl1lW7JBBY6uOAz
         tn3zi1jkjIdY/j744PNldwMqQVieQrxwFYlvMFFa70RxnLJEIAMsiIPCs0S2NOL/pKP9
         YSM4P2+EChv7evJKqz3UfSObVRQnNFpOYv9c2bLRz5+Tjd+MCeMkLuiRUKgCsH5EPRjh
         VxmioOE5qrtKdyHT5h+48NKl2GYc7HCcVyCStG/opK78RDD4XF6fIj2knCKIAzPCUh0m
         /Whw==
X-Gm-Message-State: APjAAAXvHhHIFh6xycucMAUmvIW0ybaFc8MxjfnNNMkQWagalPuxipeT
        dP7nHKuf52H9uvzkUDBza5Wq9w==
X-Google-Smtp-Source: APXvYqwQ+7l0Qwf1PWpj0B2w8Enqkv/RKz4BzCUwjz+LcWycEccr4dvPHAqbmDkVhlVg0qlCH1QFwQ==
X-Received: by 2002:ac8:2f7b:: with SMTP id k56mr66301092qta.376.1560460643764;
        Thu, 13 Jun 2019 14:17:23 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x7sm497322qth.37.2019.06.13.14.17.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 14:17:23 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 0/3] nfp: flower: loosen L4 checks and add extack to flower offload
Date:   Thu, 13 Jun 2019 14:17:08 -0700
Message-Id: <20190613211711.5505-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Pieter says:

This set allows the offload of filters that make use of an unknown
ip protocol, given that layer 4 is being wildcarded. The set then
aims to make use of extack messaging for flower offloads. It adds
about 70 extack messages to the driver.

Pieter Jansen van Vuuren (3):
  nfp: flower: check L4 matches on unknown IP protocols
  nfp: flower: use extack messages in flower offload
  nfp: flower: extend extack messaging for flower match and actions

 .../ethernet/netronome/nfp/flower/action.c    | 205 ++++++++++++------
 .../ethernet/netronome/nfp/flower/lag_conf.c  |   4 +-
 .../net/ethernet/netronome/nfp/flower/main.h  |  12 +-
 .../net/ethernet/netronome/nfp/flower/match.c |  14 +-
 .../ethernet/netronome/nfp/flower/metadata.c  |  28 ++-
 .../ethernet/netronome/nfp/flower/offload.c   | 126 ++++++++---
 6 files changed, 286 insertions(+), 103 deletions(-)

-- 
2.21.0

