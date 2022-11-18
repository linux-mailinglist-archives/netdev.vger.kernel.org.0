Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C7E62FF84
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 22:45:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbiKRVpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 16:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230271AbiKRVpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 16:45:08 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E0892B53
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 13:45:06 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id x18so4393715qki.4
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 13:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vd3+FEu+DPY99Ra5SVxmzBVi0nR163x485Mxu3tP/WM=;
        b=oHJbf5v4d2tS2lfjF5FbP5J+VZq/Iewsyhxbz76GRxV4YKcQrJjFH0CK6DoHQ/r/Ij
         2qZBGRVoDgUybH93Ojhd4IGlvLgWvyOmJLIKXpVLy6b4gJzTzw0qnEUI6XsidoFgNlGF
         ugfM87w9SbJl/itLhyz76KfOt8gcPkW7EsRW4bXfdu8n6yVWq2rAOxIZdRB9mwKNl8gK
         JjurpmT3D44jpSc3VVq4ZtqxNZFE2TG5/e7+ddh2bReYFBKzbXBJb36LRG4eIYUV2gpP
         FSeB31A1Po3QfFjt/WTL9+Ku+pIh1lUAPpO6saU5dTPFb8twGYxwPty4lgacGPifdUMO
         cnWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Vd3+FEu+DPY99Ra5SVxmzBVi0nR163x485Mxu3tP/WM=;
        b=OVz8w10ohP1IL6cGO9O0bOzdJAslRB5Lnavf/UPK7iVhC9Pdh54GkbPAVkFXKTX3/u
         YE6af+EwYUIDX6K009qr4ODqruXNvWP6pw3RwvmyuX1cubc5FvXnFtvKKF+A7hQyezD2
         h9YvUK7KMd9pw/Me1pSvxxQtcyte3pj9qkYwIiz88ZzgYNmzkr1DTxB18fSFmwmWv8Jw
         f916cuGsFY7YoFkzsqP9OcGnIFlGTsGb5TB4yU6UkBVYZIfSWZ/DpNqNA0NEE6GHTmHJ
         ESheJvAy1OUAWbNPWHKlgpiwqvMmYuoTmwFBKMlRFxH8jORve6eNnk67vYbXTrT9pyvX
         050Q==
X-Gm-Message-State: ANoB5pleDx/RhslntSfg2LXNxXfBqhoPq8PZ6BlRKeQEUsJqiijlldut
        VPBcbRKW5gCVGaZ8yLYlNdXn+5DxhGFnAA==
X-Google-Smtp-Source: AA0mqf7FX7wpmEG+aE0lBmfQxUdOIhjArlb0ct8t5ZC3ocYOMLuVQCTV5L2X9mlTCY7P7g+m9vNvEg==
X-Received: by 2002:a05:620a:318b:b0:6fa:442d:f486 with SMTP id bi11-20020a05620a318b00b006fa442df486mr7279267qkb.533.1668807905624;
        Fri, 18 Nov 2022 13:45:05 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id bi41-20020a05620a31a900b006f956766f76sm3232917qkb.1.2022.11.18.13.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 13:45:05 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Wei Chen <harperchen1110@gmail.com>
Subject: [PATCH net 0/2] tipc: fix two race issues in tipc_conn_alloc
Date:   Fri, 18 Nov 2022 16:44:59 -0500
Message-Id: <cover.1668807842.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The race exists beteen tipc_topsrv_accept() and tipc_conn_close(),
one is allocating the con while the other is freeing it and there
is no proper lock protecting it. Therefore, a null-pointer-defer
and a use-after-free may be triggered, see details on each patch.

Xin Long (2):
  tipc: set con sock in tipc_conn_alloc
  tipc: add an extra conn_get in tipc_conn_alloc

 net/tipc/topsrv.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

-- 
2.31.1

