Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C36B54B7DC
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 19:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344635AbiFNRk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 13:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343881AbiFNRk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 13:40:58 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97F732F668
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 10:40:57 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id c2-20020a25a2c2000000b0066288641421so8156615ybn.14
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 10:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fN++imAe2+eYcoBBi6+d546xeGKr7h01CKdNVJ1jyrM=;
        b=lraOA7k1h5P/Gwj7H690ObskLo3ZWcv0pPflpRdQUItG4ZqXKXVnTP+vljrII91bJL
         3g63f+7XlGwqPY5R1zsvZ/81mM9bKOwRvdfUZ06Sgk5uDt7Eq1gpORv+BsqjuAYE+EWA
         EDDwDmo8At2byBdmREA/s5C+TzW0MCOJGlKc+9FGdEkPwX0DNyJb9kI93XKzEXz39myZ
         9aHOljabLUz3OVfsPpJcXSDGuHoJk/dBpL8C44mVjcBCNWnJTZ2kdORElf4hDjbK709y
         GS/58a+AFO0psZuemyKBzO7PcDSJ4igYlbpZ2CdtD6IBS0YdpxMD7lOawgm7nCct/ubP
         JI2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fN++imAe2+eYcoBBi6+d546xeGKr7h01CKdNVJ1jyrM=;
        b=Y92eFA347yYWi1yKTgYNFeCOjfNir8JMZ56A4ura3zK+gpmS8z35TKq6nrwZ69rqoK
         wfdSnpIrAf2VRFKZsZJ6LpEqdx0qNM6Kqkc6ENZJRuRXtQbFXhMcup4FRguAiZrbkv9x
         54T+FAnjJCMADXbZUjTlF1Fw6MdM+FNEQRXVz1EI9lg0ne8Z3EA6vBjBDU0CqVOdojR5
         NaByWncVZPqXRLxHujgXcPjHsrqHV4jAiirnnK5tx/HsJ072Aa3qBfJ7X3zz7BUugagK
         ybCXa3nixTDWfgqDAmY39FbVe1ZsqfKqGmSFqw0WFzDEYGz2BCI9gPZmmRftGItcNHRW
         i8jg==
X-Gm-Message-State: AJIora+qrDs9cvOwAw4KiulWSfGVxTi9ojWOF/kNGcFMieKdweD71+wu
        uLe/ymwdjXvxqXiFveoybfm9GsbqlYULlA==
X-Google-Smtp-Source: AGRyM1sDUQWtcRZoqp6gWupUB2l7V8XB5lWrWVn0HVrDDo3bcs9MSm/0XO7dyYifG1NkJfNqlU+xdxedyMsBlg==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:28b])
 (user=shakeelb job=sendgmr) by 2002:a25:bbc6:0:b0:64b:34e1:75fa with SMTP id
 c6-20020a25bbc6000000b0064b34e175famr5910004ybk.497.1655228456801; Tue, 14
 Jun 2022 10:40:56 -0700 (PDT)
Date:   Tue, 14 Jun 2022 17:40:53 +0000
In-Reply-To: <20220614171734.1103875-2-eric.dumazet@gmail.com>
Message-Id: <20220614174053.6kkrgwedqfdva4rv@google.com>
Mime-Version: 1.0
References: <20220614171734.1103875-1-eric.dumazet@gmail.com> <20220614171734.1103875-2-eric.dumazet@gmail.com>
Subject: Re: [PATCH v2 net-next 1/2] tcp: fix over estimation in sk_forced_mem_schedule()
From:   Shakeel Butt <shakeelb@google.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Wei Wang <weiwan@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 10:17:33AM -0700, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> sk_forced_mem_schedule() has a bug similar to ones fixed
> in commit 7c80b038d23e ("net: fix sk_wmem_schedule() and
> sk_rmem_schedule() errors")
> 
> While this bug has little chance to trigger in old kernels,
> we need to fix it before the following patch.
> 
> Fixes: d83769a580f1 ("tcp: fix possible deadlock in tcp_send_fin()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
