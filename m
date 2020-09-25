Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCAF2789BC
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 15:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728431AbgIYNiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 09:38:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728171AbgIYNiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 09:38:12 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CD96C0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 06:38:12 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id m186so1911461qkf.12
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 06:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=MlAtAnHbJTbsybiHQ9AWtMquEw0h6bfQ19fynie3o7M=;
        b=TzY3gxIheCoQNpmOx9BFtOeEFH37E+kYlPZIT1P2UObJoCP/uTlue1Uj+/R3ZK1/wH
         Em5U6GN97SOqEk1eqqQtY+CsMhCmSuftginlZngDxiTjlsR3att2tiKppQJKJE8miLQE
         g0gPjomMey1TtRySglAELNM+6ckp9vKLxAAv1xh0hty7EAmgTVGwSOVp7PjUnLf8UPbt
         TrAcXG+LbOQCGditymTJ7NLia+Huhxx+VLkBWRn5n2sc2/Psy1Dm3SEU0zaCFuAznr7Y
         dA2ko9Zt110CgWpzrkWEM+wavodVYmxQFwR+syyYHz+ZxYenzMNFZzMD3H+liNVAD3jK
         56Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=MlAtAnHbJTbsybiHQ9AWtMquEw0h6bfQ19fynie3o7M=;
        b=uSq+7BZeoOB91zew7qzA84D7/5nKyYKIh8Ok2+DVPgURDmc0VDagaRyVlhQWXdZGjG
         9aNpXi7/MEiRnWc7KdF2XjCVMy6Ia118Y983u1er81HHtDFYrQr/jvQWbVWtuH97ns6p
         UvTmY6Tm3lNg8OmDF89dwtgMiSXX1SNkvEAgHTV2QIioWKGBJ7fHrEt8MS34qAemjsUN
         VHcyLhGulTixLTHr9d4h1NZJ6euVT8xcxv5MxCFZoNqHLkyJCtXeyfcqQ+fGsS/ta694
         D0apeXvGiDI6TiWQBTpP802P74vIV6ATFnqoNku4LbvrLdyvhO4V9/uRrYvhRy9mnO5F
         n1og==
X-Gm-Message-State: AOAM5336zrJOXlqkSIfiWTnVBkSqRkaacuXWYNfhFieSi4cJlHbsL9Xg
        pThW2DUPDAsZsjbwm5g3nt/ZMyNzEhG0kw==
X-Google-Smtp-Source: ABdhPJxtHdBEYTY8hdeJks73szXwYGZ9kBFSY7byfhNju1ztaNaSOb3liJnI17q/y6D2nKLxJOouUvgrnu/tew==
Sender: "edumazet via sendgmr" <edumazet@edumazet1.svl.corp.google.com>
X-Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:7220:84ff:fe09:1424])
 (user=edumazet job=sendgmr) by 2002:a0c:b251:: with SMTP id
 k17mr4476513qve.53.1601041091353; Fri, 25 Sep 2020 06:38:11 -0700 (PDT)
Date:   Fri, 25 Sep 2020 06:38:06 -0700
Message-Id: <20200925133808.1242950-1-edumazet@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH net 0/2] bonding/team: basic dev->needed_headroom support
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both bonding and team drivers support non-ethernet devices,
but missed proper dev->needed_headroom initializations.

syzbot found a crash caused by bonding, I mirrored the fix in team as well.

Eric Dumazet (2):
  bonding: set dev->needed_headroom in bond_setup_by_slave()
  team: set dev->needed_headroom in team_setup_by_port()

 drivers/net/bonding/bond_main.c | 1 +
 drivers/net/team/team.c         | 1 +
 2 files changed, 2 insertions(+)

-- 
2.28.0.681.g6f77f65b4e-goog

