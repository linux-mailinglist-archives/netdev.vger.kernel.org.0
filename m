Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE92F500B68
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 12:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237742AbiDNKsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 06:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242534AbiDNKrh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 06:47:37 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E357DE10
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 03:45:13 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ks6so9274635ejb.1
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 03:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wK3Vu/zllzq8WW1cGsouYUQlE32V/v7LYbuG4KARwww=;
        b=iWo3MuKhvQmURfId57Q9uVQNBSA37QsqxkHYuHTUlbM4DFyctAvxrqNB/IKdRzrNOD
         zJqUM34hZ268u8gA/eQsmhLSaeJqqFsEuoEerQ4HgjmrjgyRkWR+FbFn0QDRB9rtQId9
         JiKuZjBHR9Be84RkQ9KZm0tWSbz8uNDRMkEEU8VfjgNX5pYy7Uk9l6Dx4PhytkF5f+l6
         FQZVuwkpGSbnaIp37yQTI3jpdNRqxxq61/mIAQdMxhrgexjZPeOUZrArpb1p0HejOXtz
         IJLEFTlraweDr79RyAW072wL5wLxjB37KWYNPYSDbZJRp5McegC9XhxrRsyZAfCUb5vP
         AdAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wK3Vu/zllzq8WW1cGsouYUQlE32V/v7LYbuG4KARwww=;
        b=bQZVlatfMfEY39s8if9YrXBbW2MKwnl6o96U7J3yEaql/gSfN9gqmt1sz0t7HUY4Z/
         PPP/UPcPET0mtgM+RP7/tPP4sCjvoxJNmAhP0FAak3Phx6eYmcWLmt2s1FE+WmaNqpag
         KQMecpj58QqXW0w4T2l+zFGiASO0DkJNob5dqe3lSVPfTXqkv8pcjF0h+n60ysSDi+By
         5DijFX6MQ1DI6u95Utk4zmT7+hTYepxVMLDzNEq27hZVplAycLoU7429nHNfRm0cQvrR
         oII3m9SDt4kenp0ReeMM3arGgDmFZF18+LV2UOhR8JvyI589RoF3l34L3Bpqt+rICqEK
         S+UA==
X-Gm-Message-State: AOAM532GYsvmFfBJO0+tkGH/NNGu7LdjiPQmBNHClv2VXj3PJVeXblIp
        1cJy9pYIugL2aKSmCDSQHVT27U276NAhkris
X-Google-Smtp-Source: ABdhPJw+lUQ4hQwaZcm0NYtAWY2TeyGXIOIdTleMr9lZonqxWXnefd5lDNruLr7zmdbdkrs7EzX8pQ==
X-Received: by 2002:a17:907:7205:b0:6e7:ee50:ea94 with SMTP id dr5-20020a170907720500b006e7ee50ea94mr1732651ejc.351.1649933111632;
        Thu, 14 Apr 2022 03:45:11 -0700 (PDT)
Received: from debil.. (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id hy24-20020a1709068a7800b006e888dbf1d6sm504984ejc.91.2022.04.14.03.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 03:45:11 -0700 (PDT)
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     netdev@vger.kernel.org
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Martynas Pumputis <m@lambda.lt>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, wireguard@lists.zx2c4.com,
        kuba@kernel.org, davem@davemloft.net,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: [PATCH net 0/2] wireguard: device: fix metadata_dst xmit null pointer dereference
Date:   Thu, 14 Apr 2022 13:44:56 +0300
Message-Id: <20220414104458.3097244-1-razor@blackwall.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
Patch 01 fixes a null pointer dereference in wireguard's xmit path when
transmitting skbs with metadata_dst attached. Patch 02 adds a selftest for
that case using bpf_skb_set_tunnel_key on wg device's egress path.

Thanks,
 Nik

Nikolay Aleksandrov (2):
  wireguard: device: fix metadata_dst xmit null pointer dereference
  wireguard: selftests: add metadata_dst xmit selftest

 drivers/net/wireguard/device.c             |  3 +-
 tools/testing/selftests/wireguard/netns.sh | 63 ++++++++++++++++++++++
 2 files changed, 65 insertions(+), 1 deletion(-)

-- 
2.35.1

