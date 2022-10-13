Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8485FE226
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 20:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbiJMSzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 14:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbiJMSy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 14:54:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701B9DBE48
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 11:53:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665687069;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=8pkajZPOZxDkGw1RxC1xTCn1Bly76di5EaF0TtIpiUE=;
        b=FT/U4atbl2SjlTNnzGd66W/q+Lri2Kv+zprL4BB0cOVC+BcROzCSVjjSc5LK0WeB/CHDpE
        6cOVo89l8V7Fisvy9KJ06GvTVbGd42emfUlmrpkQHv6EgO91juqXPGCGqbdJjS8tI9kl2I
        mPYNYq9Q+62mCItEqbL4VZDdeJVzCVU=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-369-hWUxas2AO7iOSRHtmYEjRw-1; Thu, 13 Oct 2022 14:40:50 -0400
X-MC-Unique: hWUxas2AO7iOSRHtmYEjRw-1
Received: by mail-oo1-f71.google.com with SMTP id x26-20020a4aea1a000000b00480a4135181so935371ood.15
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 11:40:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8pkajZPOZxDkGw1RxC1xTCn1Bly76di5EaF0TtIpiUE=;
        b=LuvMDJJcPsits8vEcWgyaHurj7HawDxIHcJ46Q1HA3GrZj92H4xirdm3Twvb/K8BTK
         Wk9/+xJrFoBzhBINfEyeu496nCj9evWhIQ/ozSwm1mCuwYSNDCscm34kCEqzCKN3B2u3
         q8fajDVylvT2N2/eDeGbkPFRE6NII/gwmU+ERffWaCDQ1volGHmf6a3arCdbx3lsYeoT
         TQjT6rBU3EqxVctg7xAAqtHNKfcJD+5e6b864NRnN5UBJrVj0TMP3yELmnj6NSuGwSI/
         qYHShNbTGdnWEls4hkTzIVP3qBMVky6cziSr+rb1kCuy+Gr8DBCwSRz4FGAjbA2GHlPB
         LISw==
X-Gm-Message-State: ACrzQf2Eeaq7AUFqBlkKOEx5m7wTspVfyjdRIt/CsNBGY1qJLC9zAS5K
        br1y6VdFC3OvUCbGwVxr1/SamJ/EwnFYHJvE5AO5lEskjs1BuH+Zy8DP6ikyHIAWpME4zT1Zita
        oANzJHwfh1GzJlnhi
X-Received: by 2002:a05:6830:2647:b0:659:edd8:3fcd with SMTP id f7-20020a056830264700b00659edd83fcdmr681875otu.344.1665686449483;
        Thu, 13 Oct 2022 11:40:49 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5zsqe12qXgtGqOG3X4aAkxg5HN1AkA2/2fmrv6WsfdypDLxNxz0oYk6/aTlQR85OUwZLjPpA==
X-Received: by 2002:a05:6830:2647:b0:659:edd8:3fcd with SMTP id f7-20020a056830264700b00659edd83fcdmr681866otu.344.1665686449258;
        Thu, 13 Oct 2022 11:40:49 -0700 (PDT)
Received: from localhost.localdomain ([2804:1b3:a801:9473:d360:c737:7c9c:d52b])
        by smtp.gmail.com with ESMTPSA id v13-20020a05683024ad00b006618ad77a63sm244521ots.74.2022.10.13.11.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 11:40:48 -0700 (PDT)
From:   Leonardo Bras <leobras@redhat.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Valentin Schneider <vschneid@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Leonardo Bras <leobras@redhat.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Phil Auld <pauld@redhat.com>,
        Antoine Tenart <atenart@kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Wang Yufen <wangyufen@huawei.com>, mtosatti@redhat.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v2 0/4] CPU isolation improvements
Date:   Thu, 13 Oct 2022 15:40:25 -0300
Message-Id: <20221013184028.129486-1-leobras@redhat.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Patch 1 removes some noise from isolation.c

Patch 2 adds some information about the housekeeping flags and a short
description on what to expect from the HK functions. I would really like 
some feedback on this one, since I got all that from the flags usage, and 
maybe I am misreading stuff.

In patch 3, I am suggesting making isolcpus have both the _DOMAIN flag and 
the _WQ flag, so the _DOMAIN flag is not responsible for isolating cpus on 
workqueue operations anymore. This will avoid AND'ing both those bitmaps 
every time we need to check for Workqueue isolation, simplifying code and 
avoiding cpumask allocation in most cases. 

Maybe I am missing something in this move, so please provide feedback.

In patch 4 I use the results from patch 3 and I disallow pcrypt to schedule 
work in cpus that are not enabled for workqueue housekeeping, meaning there 
will be less work done in those isolated cpus.

Best regards,
Leo

Leonardo Bras (4):
  sched/isolation: Fix style issues reported by checkpatch
  sched/isolation: Improve documentation
  sched/isolation: Add HK_TYPE_WQ to isolcpus=domain
  crypto/pcrypt: Do not use isolated CPUs for callback

 crypto/pcrypt.c                 |  9 +++++---
 drivers/pci/pci-driver.c        | 13 +----------
 include/linux/sched/isolation.h | 38 ++++++++++++++++++++-------------
 kernel/sched/isolation.c        |  4 ++--
 kernel/workqueue.c              |  1 -
 net/core/net-sysfs.c            |  1 -
 6 files changed, 32 insertions(+), 34 deletions(-)

-- 
2.38.0

