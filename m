Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EED8811454F
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 18:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729793AbfLERDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Dec 2019 12:03:55 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41423 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbfLERDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Dec 2019 12:03:54 -0500
Received: by mail-wr1-f66.google.com with SMTP id c9so4509726wrw.8
        for <netdev@vger.kernel.org>; Thu, 05 Dec 2019 09:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=r42H/4xnyZ9H1hWkpv67TGHgq2sSx9vk59yx3z+dWmg=;
        b=F5r5csE18g0GpeNGhBLLwfqGjW573TzuDCor0GTkMCG3L76Zlp+9srDECst/ULL1mi
         7mMwtbu0L4V0QfClctOzXFh/U2H55bGBpewrmANb0zH8Ar6nnP+pLQ1JhnfQWLOGzi68
         o45WfT66rx3FliGZXXxOqDBw0XWKULvz44o0g5WZRE9HNnt4HlnKTZ6UpxmG69dR68ft
         mLDubVCNx6PPZaRh9ohgVtCflcp7uFJa1ZkPyaQ6I6vR1hMIIolxSFP7eyXkvKNjLqMb
         k8nkwKBi5Sok6T80sHKUCEFe3TtOSo+Icf70+/c9myGZ/XIKfvjHoPri/13jk+HmV0cq
         vfIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=r42H/4xnyZ9H1hWkpv67TGHgq2sSx9vk59yx3z+dWmg=;
        b=VXPlS/jor9of95rXc0P2Ec5MR6NXRADLqYvkvd9oQKOypjh83HTQOvAljib7CAwcTu
         FJ8Frmeo7+wWAZs4D2v2AEGKXvdjMz4l6ynEp3QsxwzOZvNYpvrs8ELvNujRLWWnHuVB
         94GgUkdscb6n0xU/0jAiUjxwxQGAVe3/7Fa0z9JDRF//Yg0jiwAZegwF6E4+OoU1JA18
         5iQvxDEcT3TvDT9sEYpWQWqROX5M74ZBz/KQeyEAfv8OKyj/rSlBzsaYYjbwBC4GqGHx
         JKCZtr7UzfK7SESlSdS405efD25FhcSeXofSrX1Uyr+pLxJCl8YEyEB0wPGWHNRJaAKf
         Bqzg==
X-Gm-Message-State: APjAAAVhLZXeHMnfnJPhU8xoB8hh8FNPPDfctLD/HkXHK5QFx1HKDHll
        mdJjxT9fWLlnfgYn+SdNEFqusq1q+ZC+4RKGkf8Czy17JzG1KRcb+ye6HArz4JHE3tk8KVINRN+
        MLI4MVXiV5plPIemL8EWuMAsWx7QED5gKyDbGQwEtinHXDyM/yyFRq/Enj0fQ0XbG0xIsNI5XKg
        ==
X-Google-Smtp-Source: APXvYqy/UTApjp/GhyRZwORZSrWBJ9oAoDjGsmgSj0BgikRqnJI4dr3r5HmQ8+AYybZ9lbKSbIVK+A==
X-Received: by 2002:adf:fa0b:: with SMTP id m11mr11145426wrr.98.1575565432522;
        Thu, 05 Dec 2019 09:03:52 -0800 (PST)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id b2sm13004971wrr.76.2019.12.05.09.03.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 05 Dec 2019 09:03:51 -0800 (PST)
From:   John Hurley <john.hurley@netronome.com>
To:     netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [PATCH net 0/2] Ensure egress un/bind are relayed with indirect blocks
Date:   Thu,  5 Dec 2019 17:03:33 +0000
Message-Id: <1575565415-22942-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On register and unregister for indirect blocks, a command is called that
sends a bind/unbind event to the registering driver. This command assumes
that the bind to indirect block will be on ingress. However, drivers such
as NFP have allowed binding to clsact qdiscs as well as ingress qdiscs
from mainline Linux 5.2. A clsact qdisc binds to an ingress and an egress
block.

Rather than assuming that an indirect bind is always ingress, modify the
function names to remove the ingress tag (patch 1). In cls_api, which is
used by NFP to offload TC flower, generate bind/unbind message for both
ingress and egress blocks on the event of indirectly
registering/unregistering from that block. Doing so mimics the behaviour
of both ingress and clsact qdiscs on initialise and destroy.

This now ensures that drivers such as NFP receive the correct binder type
for the indirect block registration.

John Hurley (2):
  net: core: rename indirect block ingress cb function
  net: sched: allow indirect blocks to bind to clsact in TC

 include/net/flow_offload.h        | 15 ++++++-----
 net/core/flow_offload.c           | 45 +++++++++++++++++----------------
 net/netfilter/nf_tables_offload.c |  6 ++---
 net/sched/cls_api.c               | 52 +++++++++++++++++++++++++--------------
 4 files changed, 65 insertions(+), 53 deletions(-)

-- 
2.7.4

