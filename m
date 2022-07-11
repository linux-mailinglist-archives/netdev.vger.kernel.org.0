Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91CA557097B
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 19:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbiGKRvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 13:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiGKRvR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 13:51:17 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3591A1837A;
        Mon, 11 Jul 2022 10:51:17 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id a15so5481990pjs.0;
        Mon, 11 Jul 2022 10:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rrOzhywtUZcDgT5kKp/VKA1qOiqCgnQehuHAvAboq14=;
        b=NZHoQTQwPxtdWO0Wjfnz+nmzhsBOtIcYrvVjd0Sz1cJ5HVOZHmo+CB9c/6xEcMIA9I
         FaGYrT20JatDEeGRZ/RDYldE2f5H5F6JM8ZxL2lTqOdQu185JL5NT/CfQg+TYAucg8Cj
         g9nU2f729m2opk6EgNe4pnc1qS6eBvciSt7u13geDCS7rBET6R/WITQ0GbR+ydCVqSzg
         0v0Fm3daEHBBiVfU6sKE2DgmrycihPyV3lBInifMdSo8iL8Pb/iIP4hYTZ8jBhpWiO+z
         aUZKSGoyeguNGvPfw89T209UypVpdcUIM6aKCgWRkA87cSQujFyDCQ3VqeubFk5z+pWZ
         slPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rrOzhywtUZcDgT5kKp/VKA1qOiqCgnQehuHAvAboq14=;
        b=uj2CmP3OZWzDXJqB3Nf5dPFwwsEHTcHonQ89JAvnzC9I/b82BQAgETczGMBGUSAjDD
         k4C+NwMfiKzED8GchFcExgnpJ/9GP9cf6emgUcJlIhuf+sRvjLDqi4HE0sOt/p15v47W
         pEHlcO/Q7Ft0H5mUbNRV4Hjyu8YsYku99wR6KqPZtkQenFWeK29TaPDKgGMKwqt9aZBq
         9VulRQr3qYhMqW2uUE/xN0jf93IRek32/nvaF//eCQXowo3m7NEWnAT2gEm4wzWAKBDQ
         jDu0JVupLpKfycB5DmV2MrAqbzHlaE2dEOAezpXmvszQWvxZFKnMAlezXxa9HKBamoFM
         cEbw==
X-Gm-Message-State: AJIora+vX5A24DETvgOTW0sRr+4FU4SQWIiDMJYig8yU8y04nGmSbriy
        aMA2v8cWm1oXKdVXi3VbVdlWFZI7dZPtk3y/RPQ=
X-Google-Smtp-Source: AGRyM1sYgrAykEpthfMR48kRSf/vAb7HCoNF1DYfi2lWjfjK73VOJuuKSIesuuLH0GNxYxFT2IZ0ig==
X-Received: by 2002:a17:902:9887:b0:151:6e1c:7082 with SMTP id s7-20020a170902988700b001516e1c7082mr19460724plp.162.1657561876407;
        Mon, 11 Jul 2022 10:51:16 -0700 (PDT)
Received: from localhost.localdomain ([64.141.80.140])
        by smtp.gmail.com with ESMTPSA id h14-20020a056a00000e00b0051bbe085f16sm5041737pfk.104.2022.07.11.10.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 10:51:15 -0700 (PDT)
From:   Jaehee Park <jhpark1013@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, linux-kernel@vger.kernel.org, aajith@arista.com,
        roopa@nvidia.com, aroulin@nvidia.com, sbrivio@redhat.com,
        jhpark1013@gmail.com
Subject: [PATCH net-next 0/3] net: ipv4/ipv6: new option to accept garp/untracked na only if in-network
Date:   Mon, 11 Jul 2022 13:51:15 -0400
Message-Id: <cover.1657556229.git.jhpark1013@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch adds an option to learn a neighbor from garp only if
the src ip is in the same subnet of addresses configured on the
interface. The option has been added to arp_accept in ipv4.

The same feature has been added to ndisc (patch 2). For ipv6, the
subnet filtering knob is an extension of the accept_untracked_na
option introduced in these patches:
https://lore.kernel.org/all/642672cb-8b11-c78f-8975-f287ece9e89e@gmail.com/t/
https://lore.kernel.org/netdev/20220530101414.65439-1-aajith@arista.com/T/

The third patch contains selftests for testing the different options
for accepting arp and neighbor advertisements. 

Jaehee Park (3):
  net: ipv4: new arp_accept option to accept garp only if in-network
  net: ipv6: new accept_untracked_na option to accept na only if
    in-network
  selftests: net: arp_ndisc_untracked_subnets: test for arp_accept and
    accept_untracked_na

 Documentation/networking/ip-sysctl.rst        |  48 +--
 include/linux/inetdevice.h                    |   2 +-
 net/ipv4/arp.c                                |  24 +-
 net/ipv6/addrconf.c                           |   2 +-
 net/ipv6/ndisc.c                              |  29 +-
 tools/testing/selftests/net/Makefile          |   1 +
 .../net/arp_ndisc_untracked_subnets.sh        | 281 ++++++++++++++++++
 7 files changed, 360 insertions(+), 27 deletions(-)
 create mode 100755 tools/testing/selftests/net/arp_ndisc_untracked_subnets.sh

-- 
2.30.2

