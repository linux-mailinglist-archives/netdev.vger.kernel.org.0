Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0D15D2A5
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbfGBPUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:20:47 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43243 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfGBPUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 11:20:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id f25so7836384pgv.10
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 08:20:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Vy/yZ/n5ClLY1qISZNlSWGbzy8L79W0QJBOBUkiGiwc=;
        b=CGxwPWNCA3mybOVTqjzzkpmGfFV2Vrm0m50eQAI8eqVBu95IDnHwerya4iMFeQ7DL7
         awFq6it2K4WLi2ixTYXn+Dx0/7/2G6YugluzatCv+gYDW9kBJLqDu241mDkwPko7haqm
         EI49YsZu82Kayhh7y/lMC8jkxg7C81/OJQs0pSVKEjfmcCB1YKh1ypSwp7nZgNRuZO9q
         kNU4FWBI8paMlT9F17pNLjYSme5CfMz/As8ZZi7rkntNggvvH0BKpkuDpX4PuQLlFpT1
         fhFGM9Mi+zT7KLll2ZCcoeZWnHtxzsI0o1weuDCiGECtDayvjymd7Y4ngSMWWJkY6it6
         QaGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Vy/yZ/n5ClLY1qISZNlSWGbzy8L79W0QJBOBUkiGiwc=;
        b=qHDOIUnm6KRMMpOhNNUQykPp4VbdRL4A+sqHug5ySj+VWFqkBhKOlXCvEyUWl+jpEg
         aC03XSDXbDxx4YR3TG/gF7hQNddipMuy/n/CijL7l8SexvVpSOqb3iLS5o8N7NVLsPHx
         6p+46j7KkkvrMQh5X4MwXjBft0ccSN0prXvxkyDzisGfwAzXbdWGHfV7fSMZ6GlzcFqF
         bQ0GYIobntI48ZVG679l62w5yaX+Ble7n2OYE7VYdXgU4Vym2Idr27GKPNEDzSdFGeXo
         eit5j1bY7HaSUBG4ibBlic7MKS78grOBq1KsihjT1tYrEOkxCQTzhbdtX4rC6owEgFq7
         /zww==
X-Gm-Message-State: APjAAAUvqe5BH5WVUiJ1AU6rfn7ZhjEj6bxZ6/sT1hURtfkN9cku338q
        0uGO5cTbBlN7xASvGxA76xF9mea2dac=
X-Google-Smtp-Source: APXvYqwIpIT/ewZBvuE1KwHMVr4758qCSfWkqIaLCMGJHtRRi8W2dMDFyHbkkf/opVpK9cMvFc5qLQ==
X-Received: by 2002:a17:90a:1aa4:: with SMTP id p33mr6274593pjp.27.1562080845980;
        Tue, 02 Jul 2019 08:20:45 -0700 (PDT)
Received: from ap-To-be-filled-by-O-E-M.8.8.8.8 ([14.33.120.60])
        by smtp.gmail.com with ESMTPSA id c98sm2919647pje.1.2019.07.02.08.20.43
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 08:20:45 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 0/6] gtp: fix several bugs
Date:   Wed,  3 Jul 2019 00:20:34 +0900
Message-Id: <20190702152034.22412-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series fixes several bugs in the gtp module.

First patch fixes suspicious RCU usage.
The problem is to use rcu_dereference_sk_user_data() outside of
RCU read critical section.

Second patch fixes use-after-free.
gtp_encap_destroy() is called twice.
gtp_encap_destroy() use both gtp->sk0 and gtp->sk1u.
these pointers can be freed in gtp_encap_destroy().
So, gtp_encap_destroy() should avoid using freed sk pointer.

Third patch removes duplicate code in gtp_dellink().
gtp_dellink() calls gtp_encap_disable() twice.
So, remove one of them.

Fourth patch fixes usage of GFP_KERNEL.
GFP_KERNEL can not be used in RCU read critical section.
This patch make ipv4_pdp_add() to use GFP_ATOMIC instead of GFP_KERNEL.

Fifth patch fixes use-after-free in gtp_newlink().
gtp_newlink() uses gtp_net which would be destroyed by the __exit_net
routine.
So, gtp_newlink should not be called after the __exit_net routine.

Sixth patch adds missing error handling routine in gtp_encap_enable().
gtp_encap_enable() will fail, if invalid role value is sent from
user-space. if so, gtp_encap_enable() should execute error handling
routine.

Taehee Yoo (6):
  gtp: fix suspicious RCU usage
  gtp: fix use-after-free in gtp_encap_destroy()
  gtp: remove duplicate code in gtp_dellink()
  gtp: fix Illegal context switch in RCU read-side critical section.
  gtp: fix use-after-free in gtp_newlink()
  gtp: add missing gtp_encap_disable_sock() in gtp_encap_enable()

 drivers/net/gtp.c | 37 +++++++++++++++++++++++++++++--------
 1 file changed, 29 insertions(+), 8 deletions(-)

-- 
2.17.1

