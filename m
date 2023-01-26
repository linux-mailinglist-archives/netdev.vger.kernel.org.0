Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED65767D665
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 21:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229732AbjAZU14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 15:27:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjAZU14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 15:27:56 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F70F74A
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 12:27:54 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id vw16so8214289ejc.12
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 12:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=p6e1idkozAdyFbwzDMBHWW8sAO0btgqXBL7hMwd+oBo=;
        b=rvmm5Mwlqg15HnFqmljC0zk3wG+Tmm/MAtPRw7Z7iIY2XJM4sSAfDUGWgJ2Iz5WMUL
         aT28kc0M17ns4kNIhpn+o/UBxWC+4/Y2dE1AgaCXCnTHgjXlUnVo2s9sP1GyLHcPc+GT
         2oZCZauWaTCoKLnZrbtb2FzA6J5rANzAab0EEFBEa0mS9tqBLzPhZERUfgi8ucIVpGMd
         zjFIT7SH6+BC8FPZIu+6yjc/QTO6sG//ik+hwfWrP3tLXNwoFS7a6FM8S33knZAZs3na
         7iBG3KLKS3Oi/tlDacEcr0HKdEBE6Bfh1cIJcwfBYu9PolKJN2SiTuVSJpjvfwarCx5Y
         /QYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=p6e1idkozAdyFbwzDMBHWW8sAO0btgqXBL7hMwd+oBo=;
        b=XkR/MLZoQZNCiTdPrZtQBeVRWtDpi26ZGtTg3dcKHmsb4E3Bx94O0ltH89Vgif6JDm
         jQVLdd2dAT22Enn/w0syAE4nu9Kh1/uG8LFq4rXa9enk8TIcQVpqjtiBKRZyKj/iGboq
         JqwMwN6uLLq8mlr+QCnRoeyOtO6eX0N11VjCLlIe0le5UYiQEx72a/j02Hz7f6QAlLPy
         KZKpdAipFDdSpGJ/ZsiZ3RT7tN9UnDj01A/XL7GONhHrA4ycSg5ta2D7PwhyeMMGQds+
         3URhgS6GWwQOcuOHMP3fwYTenK9s1F6bJAfXIGVXmXfa/g+eUHaybuFRTgYgHXZTwSYA
         Fvkw==
X-Gm-Message-State: AFqh2koxPrhfAr+WQihBXbzzJZv3ZLkSOzhylAK7O++IbTk0dLobCrtf
        0elBff8rgmFTkTQjMC8HohZ04g==
X-Google-Smtp-Source: AMrXdXuQu7N2nYVtMau04TrCmrZdh4kSM3AJuPlbOZYtuWMHLYAiSPs3hcqLTqLpEtU1WRVAegP7ug==
X-Received: by 2002:a17:906:b009:b0:877:8ae7:2e44 with SMTP id v9-20020a170906b00900b008778ae72e44mr28128735ejy.5.1674764873072;
        Thu, 26 Jan 2023 12:27:53 -0800 (PST)
Received: from [127.0.0.1] ([149.62.206.225])
        by smtp.gmail.com with ESMTPSA id y14-20020a17090668ce00b0087329ff591esm1068749ejr.132.2023.01.26.12.27.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Jan 2023 12:27:52 -0800 (PST)
Date:   Thu, 26 Jan 2023 22:27:49 +0200
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Petr Machata <petrm@nvidia.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_net-next_01/16=5D_net=3A_bridge?= =?US-ASCII?Q?=3A_Set_strict=5Fstart=5Ftype_at_two_policies?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20230126111843.2544f7d1@hermes.local>
References: <cover.1674752051.git.petrm@nvidia.com> <8886e11bde5874305a26c0b7dc397923a1d5a794.1674752051.git.petrm@nvidia.com> <20230126111843.2544f7d1@hermes.local>
Message-ID: <A066ECE0-C02B-426E-9591-670CC234299A@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On January 26, 2023 9:18:43 PM GMT+02:00, Stephen Hemminger <stephen@networ=
kplumber=2Eorg> wrote:
>On Thu, 26 Jan 2023 18:01:09 +0100
>Petr Machata <petrm@nvidia=2Ecom> wrote:
>
>>  static const struct nla_policy br_port_policy[IFLA_BRPORT_MAX + 1] =3D=
 {
>> +	[IFLA_BRPORT_UNSPEC]	=3D { =2Estrict_start_type =3D
>> +					IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT + 1 },
>
>Is the original IFLA_BRPORT a typo? ETH not EHT


No, it's not a typo, Explicit Host Tracking
