Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0B0333B00
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfFCWR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:17:56 -0400
Received: from mail-qk1-f179.google.com ([209.85.222.179]:43244 "EHLO
        mail-qk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfFCWRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:17:55 -0400
Received: by mail-qk1-f179.google.com with SMTP id m14so1533742qka.10
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 15:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=veh9RwC9o0unE2+sIlfaqJShe2JcAnjIBZ8u4rCBw3U=;
        b=Np2KBFBH8hc1WbitlQhbMqRWYGc7U1eQtV0jWC9OEhZuYGs/L0ntAX1ZvL0N/POrW7
         b7sBP9lCO2OSKmaf/+3Sa61CiG/1X7IvcWRV+xkSNFsZwOsFjVxdLZNOsRI3kANT920a
         kVTMnOixW6zUgjVenhUGwcrizvJBpTQyzqOZD5to1eho/Pmh8RcQf/7avn5PhRulYS/b
         XcTR6VcLwCvcFRauLx/EzGX4jnlfM4X5sh7zzLXmmfS8UdaNDDOi9nh/FYHmQ1w6a7KO
         qeR7u87UJMprffemNFWbSBYU8Gf1wWzpNuwOW2vbD32e4bhqD19Qmi8ZwafTYfwtXswB
         cL6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=veh9RwC9o0unE2+sIlfaqJShe2JcAnjIBZ8u4rCBw3U=;
        b=lWcxjKeQKP+rZ+sZA9fT5RlshwoWiBJQe5bZ8C4A+qIVwhKhNcfVKPwiVdp0arMXts
         J9RkofZzECfF82HMjapsTawhhKrN43tCUS+oJd4ShATLTTSZ+pSiBq2hUGjjrrWb+omu
         T9yZhAV+fmHRw84UitwLxQelJ6WR+HrsO8zTJJJPZLGIyNlCmXFj1insWGukjO7e0a7L
         bSaPrpE4HsSYubCAPlomZqpiHSf9Al9e6tPFTeuTr2xY+PTdKaUsDjvN5SAPpny1MXiC
         IOCsEkZ9IdAZ8IfewX6jCJc8slkQuLRBQBCxcZXYkFEfVfikWcgliopCc4Yt8wOnM+qg
         M8lA==
X-Gm-Message-State: APjAAAWIvteb+wjfKW9CmJ36cMpbma6uSpgOy4nl3wS9qmS1rdnWMA6m
        LKs7hsygPukPhBhNcE9atxPcqg==
X-Google-Smtp-Source: APXvYqxHfErfkEiH49N7pXCaiJoFK1asGk04Y5OzLmAKN6iCxXmVZluqsezK6sn7MnmzwcJlfK8eWA==
X-Received: by 2002:ae9:c017:: with SMTP id u23mr24370508qkk.245.1559600274740;
        Mon, 03 Jun 2019 15:17:54 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m4sm4332391qka.70.2019.06.03.15.17.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 03 Jun 2019 15:17:54 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH net-next 0/8] net/tls: small general improvements
Date:   Mon,  3 Jun 2019 15:16:57 -0700
Message-Id: <20190603221705.12602-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This series cleans up and improves the tls code, mostly the offload
parts.

First a slight performance optimization - avoiding unnecessary re-
-encryption of records in patch 1.  Next patch 2 makes the code
more resilient by checking for errors in skb_copy_bits().  Next
commit removes a warning which can be triggered in normal operation,
(especially for devices explicitly making use of the fallback path).
Next two paths change the condition checking around the call to
tls_device_decrypted() to make it easier to extend.  Remaining
commits are centered around reorganizing struct tls_context for
better cache utilization.

Jakub Kicinski (8):
  net/tls: fully initialize the msg wrapper skb
  net/tls: check return values from skb_copy_bits() and skb_store_bits()
  net/tls: remove false positive warning
  net/tls: don't look for decrypted frames on non-offloaded sockets
  net/tls: don't re-check msg decrypted status in tls_device_decrypted()
  net/tls: use version from prot
  net/tls: reorganize struct tls_context
  net/tls: don't pass version to tls_advance_record_sn()

 Documentation/networking/tls-offload.rst | 19 -------------
 include/linux/skbuff.h                   |  1 +
 include/net/tls.h                        | 36 ++++++++++++------------
 net/core/skbuff.c                        | 25 ++++++++++++++++
 net/strparser/strparser.c                | 10 ++-----
 net/tls/tls_device.c                     | 28 ++++++++++--------
 net/tls/tls_device_fallback.c            |  6 ++--
 net/tls/tls_sw.c                         | 17 +++++------
 8 files changed, 76 insertions(+), 66 deletions(-)

-- 
2.21.0

