Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D4D4D2955
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 08:17:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiCIHSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 02:18:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiCIHSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 02:18:23 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE662ECC57
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 23:17:24 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id 3so2122736lfr.7
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 23:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version:organization
         :content-transfer-encoding;
        bh=eD2ryPmEU0ZNTy/H2JiHqLJN5TTANs0I2eLEy8TsqcM=;
        b=m/A8zIYGlKfoEvYZ19Ah+XBlSzAIqOwI18UnRULNvKOK85KmMqv/B+Cgx4jh7Rn3yd
         IAaSWtsMD6/wyQ3HDoTpX/FwJmR5FyVnI06f+UwTiL+DfnQhb37/Tb7LEOGjcHdZ8vtR
         WtT4LsSbIcRVAmkmxJ3WJPHz4hB1UcQ/rqJzPKNbez2rSXPrEyS9sSnXHYp9eOq8sjP4
         +Rv94exDkdQ3EJ3CUmUIv/+J1GWRi0tNMhK+aPsz4q7jkYE09yDbXT54v/fEeY0Am49T
         ILOpIAtaMy64zJ+1JYjfes5KgHHlQi1oQzmrtj5szLN7Hy0kgSvHIBvGSuppVtw/+VJg
         pOVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :organization:content-transfer-encoding;
        bh=eD2ryPmEU0ZNTy/H2JiHqLJN5TTANs0I2eLEy8TsqcM=;
        b=fFQN9DsoVBn0Cw1YIC3di5MWrqpU0rURDgCAxQZibj707Mt+mkh5DapWJ1bQPYVq47
         g24x4IaPbZ3Nd/n0Gd8nZuTkpTKHk+25t5zLlMvZxCJvcUfGw7VgprgcAKtMk7hOAy+H
         j+RUJivFEmCR9a5NyiWx8lEEbzOdZoeHDpC7gVFjUAGvIgT2eNtnVdYfIxfVtYLRnzQQ
         F9Rd8HgvTZ9SefY2kTzpmWpPksMC7e87tmicCcjwNHbzg4/e8vc2Z8Si5Qw+DhFh9qY2
         2L8TrTssqSGccagNrwVfuF7DBLKtk4+0Ni0kTJOIq2EKK5DNR44Aj6Qn7HYXGHfSzLNf
         SU6w==
X-Gm-Message-State: AOAM531icdztjvD1LtsLdZX9Hc59ZCX6jKKfjFtMecPs6SOWlZDFMjH9
        Kgs7DWQixQlQUhwrslHJZ/Bj1tY70Nm0bA==
X-Google-Smtp-Source: ABdhPJz4noLHReQx11kfYk03c6UqMW5EYiXxtnuRIeVsmjHK4nBtrui4faiK0SRhTqe12Gl4sLzkGA==
X-Received: by 2002:ac2:5c50:0:b0:448:3080:751e with SMTP id s16-20020ac25c50000000b004483080751emr8719857lfp.577.1646810242546;
        Tue, 08 Mar 2022 23:17:22 -0800 (PST)
Received: from wbg.labs.westermo.se (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id g21-20020ac24d95000000b0044842b21f34sm233730lfe.193.2022.03.08.23.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 23:17:21 -0800 (PST)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Joachim Wiberg <troglobit@gmail.com>
Subject: [PATCH iproute2-next v2 0/6] bridge: support for controlling broadcast flooding per port
Date:   Wed,  9 Mar 2022 08:17:10 +0100
Message-Id: <20220309071716.2678952-1-troglobit@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Organization: Westermo Network Technologies AB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this v2 of the patch set expands on the original by also updating the
ip/link_bridge_slave.c, and its corresponding manual page.  Both this
and the original address a slight omission in controlling broadcast
flooding per bridge port, which the bridge has had support for a good
while now.

I've grouped the setting alongside it's cousin mcast_flood, maybe we
should move unicast flooding to the same group of settings, to make
it easier to locate them in manuals and usage text?

v2:
  - Add bcast_flood also to ip/iplink_bridge_slave.c
  - Update man page for ip-link(8) with new bcast_flood flag
  - Update mcast_flood in same man page slightly
  - Fix minor weird whitespace issues causing sudden line breaks
v1:
  - Add bcast_flood to bridge/link.c
  - Update man page for bridge(8) with bcast_flood for brports

Best regards
 /Joachim
