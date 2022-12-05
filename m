Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F59B642850
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 13:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbiLEMWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 07:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbiLEMWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 07:22:20 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40497F589
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 04:22:02 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id ud5so27324891ejc.4
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 04:22:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=41xG8mQZlaOjSK+EtaRD1ZEG7HVDFEg74GMODEub3Wc=;
        b=3de8ZgklTMiQ+tI3PTx82DqYeeLrDfblAmUhSuu0Irj28BANPfKwBRhXJd1cE38iqg
         +tQpIiGl73IrTM0OpUiE6KsmC5wnoy6FFK6hx4eoazgi2wtGMLP2asRKak7CLs8aPmzl
         jwmP72g2PCCBoF8xtDUlNcjE5RBrrf8A6fs/aAMOZk2rOF5uiw1uSIexk+dU2esCaYj+
         Kf/nrnOm2G+8Etuoqam2CHd4X08fb9ziXHYwVwTDMvuXw2wvj1lpS8QWFaHCCFl7xIml
         vK+LJt05e9VSSy6y8LUUBH4zGTz+upSw/qh+zRplvYOPSdPWXChqAZEISdiAWOoZiPSE
         pKIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=41xG8mQZlaOjSK+EtaRD1ZEG7HVDFEg74GMODEub3Wc=;
        b=4tchO0gXdokDEqXJkMiHaY9EoWDhoOSb19fIYlQ3fYryEXyQvqm1Uyelo5wL3ijkzf
         GPFTC8xiWUqxOZz0g/OzjLM6Z/fUB4/NKqiyxiSrM0A6Pd6VJGWo1eydxhG40dqiCaJz
         fS9agHU6eNZ4AIx4Y1dxGdFtP//FqBhHvkfi3rXiyLQCkfxrb5jh3RRIUofxge53TKg3
         o7zSTk852IB6t+PbJpRCEuuWXHDYiXvFQ1gdzqCwH8UtIilB68sc3sM80Oz74YgRLlct
         /xj7nZmf+gbpBb+BhXgB3U+rlQ/ViAVFckSWgObjjlT2VKqREd+nDeHR0/aXPdxJI6Nc
         YHCg==
X-Gm-Message-State: ANoB5pnmco273tPX42fqwyi+Lj9Z52h/BuRpJttMSnSY999Am0cnEZNp
        7lIcvRKREdL25bPwu0Kv2Bkhr+RshPnIKA3hymE=
X-Google-Smtp-Source: AA0mqf4ILf6ricw6PTZnnGiUZ8bGv09h3T4aLY0tK0S1Ak2/HYjjiwTlKp9BPTTH6N0pTXil1jJ18g==
X-Received: by 2002:a17:906:a189:b0:7bb:8d9f:bd2f with SMTP id s9-20020a170906a18900b007bb8d9fbd2fmr41301190ejy.578.1670242920551;
        Mon, 05 Dec 2022 04:22:00 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id u19-20020aa7d0d3000000b00461bacee867sm6165653edo.25.2022.12.05.04.21.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 04:21:59 -0800 (PST)
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, kuba@kernel.org,
        moshe@nvidia.com, saeedm@nvidia.com
Subject: [patch iproute2/net-next 0/4] devlink: optimize ifname handling
Date:   Mon,  5 Dec 2022 13:21:54 +0100
Message-Id: <20221205122158.437522-1-jiri@resnulli.us>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

This patchset enhances devlink tool to benefit from two recently
introduces netlink changes in kernel:

patch #2:
Benefits from RT netlink extension by IFLA_DEVLINK_PORT attribute.
Kernel sends devlink port handle info for every netdev.
Use this attribute to directly obtain devlink port handle for ifname
passed by user as a command line option.

patch #4:
Benefit from the fact that kernel sends PORT_NEW event on devlink
netlink whenever related netdevice ifname changes. Use that to make
the printed out ifname up-to-date when running devlink monitor command.

patches #1 and #3 are just small dependencies of the patched above.

Jiri Pirko (4):
  devlink: add ifname_map_add/del() helpers
  devlink: get devlink port for ifname using RTNL get link command
  devlink: push common code to __pr_out_port_handle_start_tb()
  devlink: update ifname map when message contains
    DEVLINK_ATTR_PORT_NETDEV_NAME

 devlink/devlink.c | 177 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 150 insertions(+), 27 deletions(-)

-- 
2.37.3

