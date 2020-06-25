Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12CD7209938
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 06:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389700AbgFYEyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 00:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389460AbgFYEyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 00:54:19 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6F69C061573;
        Wed, 24 Jun 2020 21:54:17 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id d7so2450873lfi.12;
        Wed, 24 Jun 2020 21:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=spFlyvOX5WrFipaQERjg7g3CcCPYXQRDEZlGnRwq8Rk=;
        b=NpZpJwstRVsvcCrsmRFtTv2S7ydm88PJWhM4X7wUIm0I0/+gdlDt0J4CL54X+oVHGl
         ao/Wqf2p5RVvzMKdhdZqm5mM6jPqENz+nhg0ExEqv1+LVwmwfcxJEn1iZGEmsAipndDt
         /CdPhGqxs3C3fnd4ZXth8ZsXasRyYlwpdE1v80CrDqSAQIFqpjrMJfd8TjIQto3FgqvG
         BhEm/HbZPY9sFfE88M1SQw6XtIjiCXU9/aD8GeW6cxJIv8vlVicrfeYu1kCu2dpA6ha6
         S0pzjnjV+p8Y9R7J7QqaOdu9VNnuiR4H6Fq2AEWQOAJSUYdiE7S3hDMJ30rgfxWbj7/j
         jcuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=spFlyvOX5WrFipaQERjg7g3CcCPYXQRDEZlGnRwq8Rk=;
        b=MhcTLitHIkUydTAekv7AlP5Wh6JIKyaGrw5WfRh9bjnayH9JjBZDyF6h5kkiSZceos
         O2KC2cfzk5q4RorEN3L8xTvpGoNnBOXB0g/w6gkjCkCtjNM2o9lOCRn2N3qaZgVAqIoz
         WfpqueDAymog1J3J8r64BxZZnu7BFKJqMN9LhJ/qpXCQ35KNGbZt+j9DSJBh6KJrjSm2
         Db+Hz2ecgG1HvJsDNtv4/KQ0oLav3pVHLlDqkvjaMt+B92KMdxN+OyWsKYeKbD2/81HD
         Zvpfi3/5H+n/kut3VcI3uAdaATxYquyUA3ky4DQF7DHsiX7n5FArXl1QXcT+sQwfbepO
         cQ8A==
X-Gm-Message-State: AOAM5333x1reho4/M/rX5NzRrvc+w10N2lDkFwgoUA394qWXCswAeOT2
        +uiiSj3E6P7S3g4oDx7NFRBNUXP+MzTtegAoomMUVVYI
X-Google-Smtp-Source: ABdhPJyPKLHu6msNhH+qUS2yrOx/yxYvf5BIW4+VIdv40+a4CRmIqIEnT9wAnqoXcWXkaMnfNHCca8zWvWYIHN8pIYE=
X-Received: by 2002:a05:6512:550:: with SMTP id h16mr1210060lfl.155.1593060854233;
 Wed, 24 Jun 2020 21:54:14 -0700 (PDT)
MIME-Version: 1.0
From:   Jack Wang <xjtuwjp@gmail.com>
Date:   Thu, 25 Jun 2020 06:54:02 +0200
Message-ID: <CAD+HZHUdiDoODn6jpVcZrffGm2J9xe23i8BL8FrgPPCNKO6MDg@mail.gmail.com>
Subject: [Question]many kernel error "neighbour: ndisc_cache: neighbor table overflow!"
To:     Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Folks,

In one of our big cluster, due to capacity increase, more servers are
added to the cluster, and we saw from many pserver reporting error
message below:
 "neighbour: ndisc_cache: neighbor table overflow!"

We've tested increasing the gc_thresh values in sysctl.conf, after
reboot, the errors are gone

+# Threshold when garbage collector becomes more aggressive about
+# purging entries. Entries older than 5 seconds will be cleared
+# when over this number.  Default: 512
+net.ipv4.neigh.default.gc_thresh2 = 4096
+net.ipv6.neigh.default.gc_thresh2 = 4096
+
+# Maximum number of non-PERMANENT neighbor entries allowed.  Increase
+# this when using large numbers of interfaces and when communicating
+# with large numbers of directly-connected peers.  Default: 1024
+net.ipv4.neigh.default.gc_thresh3 = 8192
+net.ipv6.neigh.default.gc_thresh3 = 8192

But we still have many systems running in production, so my question
is: is it safe to apply the setting on the fly when servers are
running with busy traffic? or we have to apply the setting only
through sysctl during boot?

Most of our servers with default settings are running kernel 4.14.137~4.14.154

Thanks in advance!

Best regards!

Jack Wang
