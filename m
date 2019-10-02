Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A916C94AC
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 01:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbfJBXPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 19:15:04 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:32794 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727993AbfJBXPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 19:15:03 -0400
Received: by mail-wm1-f66.google.com with SMTP id r17so5954107wme.0
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 16:15:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=CiPRsvpa4qoQSOu26VaBG0ackWwfGGU1H8fONzha0UM=;
        b=gVfJ85APrsUTfIKDMMNW2xWG5OpDEBhl+y4t3SAXkVrBQ/18gbJECBUsjE1PeNEWvs
         PjlKfBmLKZyRQil8UVDw5QTzvowQa0m0DZU6XjWGdmalecDtoZbKftyOEDewiBtxRT2/
         pgJu9yxrmofAP1gDIIy6HFCN1czDBItdTdMET0ZNpjdHxnw96B2YbXMbpQssLfq9HXTt
         Z+3nUFqLTyAANw/F+z1c1onlS0m2MNS65Xq9aqioOdt3AR/CFCn9eICXPRLlXine9xeh
         34pIZi3eA28e/CoYP6rku89xxaMt2NQ/iRohBF+xA6iGY97gAyDRP08GsaDOG//8/vr/
         k7Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CiPRsvpa4qoQSOu26VaBG0ackWwfGGU1H8fONzha0UM=;
        b=SYHzVCkk6Cn52wlSvog7ZbncQEpUA7baCPUoZn4lxgpKOxYAq2l+tlrWkAVKmKFn5o
         uY2d/5pIPWZ7cu/v7Y6xNaUmrQUSsuRzqUCgqsHNhZQPu+x4FSCqUiDpHU1WHCtVHzsf
         +UCm1Xs+UYJB2IKRWqa5wMtTVUDyrLRnkMKCuUQlutY0EizTmNsgsGb7zVNybYiBoTam
         NnSq0RovcpQC/qek6tOjI9ofh9Y4sR09vu+7yg86cKmoii9YvzZdoIeodRiHZ1sHVRbF
         DwgRcXjDY7Pny7Bsx9oYGLTCwH9exjdiSHqD1/5lilddsRpOIyVKGzEFjXEkKl436Oxy
         72Ig==
X-Gm-Message-State: APjAAAXKIQozubWfct+W/Zc6ZKJHR/6ke7/Lb/JAaGjJRnbXq4k67P49
        ExdotXNgBBthHgYBuDkmHHs7YQ==
X-Google-Smtp-Source: APXvYqwAiZMyOKghsem4jhjJ2QX3bdR7jL67/XGUbpomsR0GgRWfa/IssOzUbFuNHY7s6jayIojeHw==
X-Received: by 2002:a1c:6a06:: with SMTP id f6mr4955946wmc.113.1570058101409;
        Wed, 02 Oct 2019 16:15:01 -0700 (PDT)
Received: from jhurley-Precision-Tower-3420.netronome.com ([80.76.204.157])
        by smtp.gmail.com with ESMTPSA id l11sm643895wmh.34.2019.10.02.16.15.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 02 Oct 2019 16:15:00 -0700 (PDT)
From:   John Hurley <john.hurley@netronome.com>
To:     vladbu@mellanox.com
Cc:     jiri@mellanox.com, netdev@vger.kernel.org,
        simon.horman@netronome.com, jakub.kicinski@netronome.com,
        oss-drivers@netronome.com, John Hurley <john.hurley@netronome.com>
Subject: [RFC net-next 0/2] prevent sync issues with hw offload of flower
Date:   Thu,  3 Oct 2019 00:14:30 +0100
Message-Id: <1570058072-12004-1-git-send-email-john.hurley@netronome.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Putting this out an RFC built on net-next. It fixes some issues
discovered in testing when using the TC API of OvS to generate flower
rules and subsequently offloading them to HW. Rules seen contain the same
match fields or may be rule modifications run as a delete plus an add.
We're seeing race conditions whereby the rules present in kernel flower
are out of sync with those offloaded. Note that there are some issues
that will need fixed in the RFC before it becomes a patch such as
potential races between releasing locks and re-taking them. However, I'm
putting this out for comments or potential alternative solutions.

The main cause of the races seem to be in the chain table of cls_api. If
a tcf_proto is destroyed then it is removed from its chain. If a new
filter is then added to the same chain with the same priority and protocol
a new tcf_proto will be created - this may happen before the first is
fully removed and the hw offload message sent to the driver. In cls_flower
this means that the fl_ht_insert_unique() function can pass as its
hashtable is associated with the tcf_proto. We are then in a position
where the 'delete' and the 'add' are in a race to get offloaded. We also
noticed that doing an offload add, then checking if a tcf_proto is
concurrently deleting, then remove the offload if it is, can extend the
out of order messages. Drivers do not expect to get duplicate rules.
However, the kernel TC datapath they are not duplicates so we can get out
of sync here.

The RFC fixes this by adding a pre_destroy hook to cls_api that is called
when a tcf_proto is signaled to be destroyed but before it is removed from
its chain (which is essentially the lock for allowing duplicates in
flower). Flower then uses this new hook to send the hw delete messages
from tcf_proto destroys, preventing them racing with duplicate adds. It
also moves the check for 'deleting' to before the sending the hw add
message.

John Hurley (2):
  net: sched: add tp_op for pre_destroy
  net: sched: fix tp destroy race conditions in flower

 include/net/sch_generic.h |  3 +++
 net/sched/cls_api.c       | 29 ++++++++++++++++++++++++-
 net/sched/cls_flower.c    | 55 ++++++++++++++++++++++++++---------------------
 3 files changed, 61 insertions(+), 26 deletions(-)

-- 
2.7.4

