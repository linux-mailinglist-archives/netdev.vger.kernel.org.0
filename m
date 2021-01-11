Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D36C22F1269
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 13:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbhAKMjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 07:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbhAKMji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 07:39:38 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91769C061794;
        Mon, 11 Jan 2021 04:38:58 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id e2so9423049plt.12;
        Mon, 11 Jan 2021 04:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=kzSOhgSOxj6CzcNeD0kd/L7wPpm8Lyfa+paUy4ruYps=;
        b=HCJnXnhoX6o99nTs15W+K3twCbtokZ7f2C4qWQaLJ2c7EflY7zOfFgPIHM4k5oDmbd
         2dohlzHDLhzYtjjXnwH7G1Ca8q5IWgKJHvbLMLQywl3CpEHrZQ8kTsVlYuNtdFVOnRT7
         FeQSSYmc6yjC0cJpvGUjurnmkRxtqrVpyULhXInw5TiPPe+3bMQlLxqNUi0+YJsH1NcE
         g48mEJUuS3QImdInZ3euaZmIGEskQ5D7yq04q92LsrBFXjwKDQL6B9KRM9G5mWI3TPm/
         HPSzlax35Qa2zuGIexMuAntTVQ5iulYzSrsh29MERCBWUxgqvxgc4qHFxgF2s6VH3UkD
         aISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=kzSOhgSOxj6CzcNeD0kd/L7wPpm8Lyfa+paUy4ruYps=;
        b=IZj69Tk51c29Qkj3ch+NlR5LnVpgnY0hTeOnQnWlEc31PP/hrS2MJAmaVh8Q5z8JJA
         C7F3eW6tUMzxUErr+geib65EM8FNUBYYp4qQeMp2IlS0QnWk4AnJvPzP0dZ9JCfEXGtm
         sHnljv48DOKxqdhzLKdOfzhm5PdIUN7mvl/phv6C4Jxw1KVLHybYMyaj1RJ5d/tz4eQy
         vJng+wQPKbHMmojtEfUZhmaj9wvK1aATen4kxYy7yfZXMWiwAhCvVBwmP++M0iiqIbBB
         SPSztarO6vZUypiC6mbWtyJa2iIMgkgxgFyhPcykSSvk2VO23ymS2wTk8cbJx2pyHC3Y
         pupA==
X-Gm-Message-State: AOAM533vr2qY+5xM7rSasy/F1YqPuCnz+4E8p1Pe/1/EwK5vO7NqfuIt
        PxNVOdLZpSXOkV/s0rRLvmz0M8Zhjg59Wg==
X-Google-Smtp-Source: ABdhPJzCqf/9tUqgfxDfU5agKtzKsR0kA9lIonok541WqPB9/Ba6h+nVXxNMSPSlQWQhswdOxuwFjw==
X-Received: by 2002:a17:902:9302:b029:da:f6b0:643a with SMTP id bc2-20020a1709029302b02900daf6b0643amr16338100plb.33.1610368737895;
        Mon, 11 Jan 2021 04:38:57 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id l21sm13387114pff.30.2021.01.11.04.38.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Jan 2021 04:38:57 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>,
        pabeni@redhat.com, Willem de Bruijn <willemb@google.com>,
        Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net-next 0/2] net: enable udp v6 sockets receiving v4 packets with UDP GRO
Date:   Mon, 11 Jan 2021 20:38:47 +0800
Message-Id: <cover.1610368263.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, udp v6 socket can not process v4 packets with UDP GRO, as
udp_encap_needed_key is not increased when udp_tunnel_encap_enable()
is called for v6 socket. This patchset is to increase it and remove
the unnecessary code in bareudp.

Xin Long (2):
  udp: call udp_encap_enable for v6 sockets when enabling encap
  Revert "bareudp: Fixed bareudp receive handling"

 drivers/net/bareudp.c    | 6 ------
 include/net/udp_tunnel.h | 3 +--
 net/ipv6/udp.c           | 4 +++-
 3 files changed, 4 insertions(+), 9 deletions(-)

-- 
2.1.0

