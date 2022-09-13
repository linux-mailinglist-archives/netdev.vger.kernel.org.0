Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05ED95B7CD9
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 00:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229653AbiIMWEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 18:04:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiIMWEl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 18:04:41 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36F26276
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 15:04:39 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id i63-20020a638742000000b00438d81c8c37so4210744pge.0
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 15:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date;
        bh=jxDIbtQ66PrWz6a32rJE0ccGslBcTnVeTR/OfIh+HdY=;
        b=Hdvb1QDi6FiIA8UOVSy7eEjRFemELD2e/V5GGGOnkjl0Txir9PJxvBIIbQeajrnuvo
         emwibrffPzGebHJyqKEesBSExuk0ZsjlHdg+vsGEZHLihzpkTMcDcW9g99XVyIPDDBdN
         opL+706gmXiI/rbnuKhSa306PeyaLZaIZQk/f2FNpvmwOWccNdcGiVtki6VD9Zwsy+iP
         qKTO9DdS92AvIOzhCk5nymjIKI5gX4lgT3o0uhENJdyJ+Gysmnpc842qsML61lHnYObi
         baW0sfyXgSEVf5GDl0KRC30fZyiTiQepS9+WcqfDlOZXOBFVm36nnxJ54HXWoeJIt+K4
         JiTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date;
        bh=jxDIbtQ66PrWz6a32rJE0ccGslBcTnVeTR/OfIh+HdY=;
        b=Ty2dhg1FnSUSJySBtKDzDOzUgEuilXuU1IXbYl9eGPWoLFo2JFxmZNed0ArScGuiqR
         pkB8BcfdYPfR7UIxzsCMMTdgk0WZrwE5uFVlJcqRp3iG8ArQayzXiEt5AFiDVGegKGdz
         S7Yx60pUUFjTeazPShL37h9d3DN+Yh5H3n2BHam5ySxzQcXD0ZmfNZzTUdAJxMmy84zX
         tBGyeIaDhzMadOWm9Pl9jxEKrXIVNggUFpslyPd67nsaMjjp593Aau099tcR9QKVezX+
         qSZSYDdqx03ExMMmrNWlQLCvpWhlgweG0uARgxZ1gCK6LHPvC+T1zybLMZdDcrIgcvut
         fapg==
X-Gm-Message-State: ACrzQf2WQ/61Ej1D1UbYUe7ZvtTvbIAWn+AN4KURlP1jqRjPZOSYm5S9
        27ZZbZxf8cXmd4p0wvRi8ghwtDZvP1EM
X-Google-Smtp-Source: AMsMyM5ghBnTaJVBUu6s4yszVZmQxi8HUmp6FZZvLliSFWGE0IKnCoL9KxrEf3upV48YWjCwepuOJXnETSdL
X-Received: from jiangzp-glinux-dev.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:4c52])
 (user=jiangzp job=sendgmr) by 2002:a17:90a:7343:b0:1fd:d6fc:b2f with SMTP id
 j3-20020a17090a734300b001fdd6fc0b2fmr1370972pjs.65.1663106679074; Tue, 13 Sep
 2022 15:04:39 -0700 (PDT)
Date:   Tue, 13 Sep 2022 15:04:32 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220913220433.3308871-1-jiangzp@google.com>
Subject: [kernel PATCH v1 0/1] Bluetooth: hci_sync: allow advertising during
 active scan without privacy
From:   Zhengping Jiang <jiangzp@google.com>
To:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org
Cc:     Zhengping Jiang <jiangzp@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This patch allows the device to keep advertising during active scan when
ll privacy is enabled, if the device is not using privacy mode.

Changes in v1:
- Check privacy flag when disable advertising

Zhengping Jiang (1):
  Bluetooth: hci_sync: allow advertising during active scan without
    privacy

 net/bluetooth/hci_sync.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

-- 
2.37.2.789.g6183377224-goog

