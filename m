Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43BC71A75
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 16:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388060AbfGWOfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 10:35:03 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46034 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730148AbfGWOfD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 10:35:03 -0400
Received: by mail-wr1-f65.google.com with SMTP id f9so43410493wre.12
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 07:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=GlQ+hPNWNqdjiTRet7GRgtjmnKPms4EOH1I2SRnQ/Zw=;
        b=q45AVrfESDeGtLq3JxF72tQhAK2+QoXVKeg4fdnS2AzbQOjPYhvq8p7lHZSox5T137
         iVLhxKJL1wYOPQIBjL5xMbBs/1YkDEMQCCaKD19dTvvIacpBLHmrJL6V2d7OHeFxU999
         RuPC4jqXxcuFFsfpwGE3b+qUqzmywTwha/7bl2kONwv/n4ij8ZuEsJ800RO1p4ubDxCe
         kPjtxYfyOM4qJTm6/n0Wp3uiRy+AeokKqussSYBkCu+eKWHc2iFmINKF7M6rXCKBzQ5R
         e15cPegOdBDsJ2Vy08vCnMfmQMmjo/TLFGXXyEt6vryBRlm2zQudh83L2owGOzsZhrA7
         iXOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GlQ+hPNWNqdjiTRet7GRgtjmnKPms4EOH1I2SRnQ/Zw=;
        b=LGg6IFjBOK5CC5M4aWtGTXrD93C3VijFHVWVJYlY4MFOU0NDIEjFqcO1oQAJe+SnYA
         o76pVXo4aKGFJO3PLg4ModVgBhgepqZ2nsOLwDAT5EbdoYjEU0vQmQ45Q5Bvb8Dg3AEj
         fjYbYOjLOzxAqfVNWHNOPTDr6LC7v1aYLc9xXsvL5Yl5LCcLtOqC6bfRIDhSOwrNNVdx
         Z/+mS1Oa0Cc8+Kz3TC6KvnadAcRWKRCUv3Q1Xgih+xsguHcN55GWIxcJRjHD865oHGtF
         zA011ZXza9V06IpcvrDFLDaOnjxPT7CMJFmXcYgvhJo7ZtPipovnVgzUC+6mA8UDNQZl
         zLcA==
X-Gm-Message-State: APjAAAUnjf74oikFmEu8nxUwxpbnYioIrTrNRjHkX3EeJ5gJJfGf/XVX
        +FW3MuBf7mg2AghFHOEb9zV36DZ1Xbg=
X-Google-Smtp-Source: APXvYqw90/spnhB+vj+/0VCdVNeUqcGHDlAwefYnmgMgmAYXeIDBDBsd4FZdCuddGuYHXb+yH/DnnQ==
X-Received: by 2002:a05:6000:1007:: with SMTP id a7mr7958974wrx.172.1563892500918;
        Tue, 23 Jul 2019 07:35:00 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id l9sm36710165wmh.36.2019.07.23.07.34.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 23 Jul 2019 07:35:00 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com,
        John Hurley <john.hurley@netronome.com>
Subject: [PATCH net-next 0/4] nfp: Offload MPLS actions
Date:   Tue, 23 Jul 2019 15:33:58 +0100
Message-Id: <1563892442-4654-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The module act_mpls has recently been added to the kernel. This allows the
manipulation of MPLS headers on packets including push, pop and modify.
Add these new actions and parameters to the intermediate representation
API for hardware offload. Follow this by implementing the offload of these
MPLS actions in the NFP driver.

John Hurley (4):
  net: sched: include mpls actions in hardware intermediate
    representation
  nfp: flower: offload MPLS push action
  nfp: flower: offload MPLS pop action
  nfp: flower: offload MPLS set action

 drivers/net/ethernet/netronome/nfp/flower/action.c | 120 +++++++++++++++++++++
 drivers/net/ethernet/netronome/nfp/flower/cmsg.h   |  21 ++++
 include/net/flow_offload.h                         |  19 ++++
 include/net/tc_act/tc_mpls.h                       |  75 +++++++++++++
 net/sched/cls_api.c                                |  25 +++++
 5 files changed, 260 insertions(+)

-- 
2.7.4

