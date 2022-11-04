Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8D6961948E
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 11:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231770AbiKDKiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 06:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiKDKiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 06:38:03 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 676E22B188
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 03:38:02 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-3321c2a8d4cso39643777b3.5
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 03:38:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gcUeaG6JKzsxRdmnLqdsuH4lvt90A/Xm+f8OuGUNx2g=;
        b=lifVXrJ64+/dFQ55o6QJG9bfmyr5u1WHnkUjB/BEPp4bwyLC2jsd5Ot2P7Kq+afJQD
         Su0nuZxTHwBvDImCVCFEUtmaSnZKHxvLUHGDg58RQELH++HOTW8K0QWx36LjdYCFjf4F
         2UF7qvnOssOdri7mk5daZe3qHYZiwwMpGyBKrmebxK/Oz60Fqe70R1pq7upF2TlYexiH
         KB4vaNLdgkNBsy0kOhH8cJKMXvp5T+wKt9Np/jANdxkDAJzzyxO+J/PUiAeGgpYOi25z
         EpBKclOxzzWRyLeZk5Zf3z7F6Dg1Z/BHhgZie9HUPmLsHUlMH97pTYmYY502125s1qbP
         SP8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gcUeaG6JKzsxRdmnLqdsuH4lvt90A/Xm+f8OuGUNx2g=;
        b=xr7J7ZR9IxenR4ThhibO2jY8qL8HcOsZQ96zxNh2TsOdtwy+QFNy+DP+jR1x23ybfk
         2EOj8XFng52T5bnZ6GmgLEF7RJ9kX5e1Zm4MVa+T1ePlkh/cEg7igrZBuhajnul7JWcs
         jpDoVR1qn5EYuZy1SNe5HbsepYZcaOvqHyyQEn/kgluwIOh1NzHK2NrIt5Sf0OWmgRjX
         kO+ngLCFXif3NENyUX6FsfqJj4naFv3RnzWLaPAQ6gFwoL8GRuG3q1i4/lg0RnzAm+5A
         xmvy9Fd5hw9xkqmol+sssZ+dzrCkVWG/HpMkZmv5BxHsLVX/F0UYT+JyxSjB17bB+EqM
         3/gA==
X-Gm-Message-State: ACrzQf35/HepuPmR+hk6j8C7Ob8MWbsAvn36L8ZZICizGxfbCRx37KVr
        vOCmgkPwcZJUBG/J13Br8kHZ00n4iQqBr++PMML0Bsl1yK4FAQ==
X-Google-Smtp-Source: AMsMyM69d9R7kJhwGNFv2ZLuCly3ihyNUT3PUT+aXZiEBSBo7oOnRn4WUjfOdGHH6UBxOLmqozRcyr4tBPT67HdCpD0=
X-Received: by 2002:a81:4811:0:b0:368:e6a7:6b38 with SMTP id
 v17-20020a814811000000b00368e6a76b38mr33471525ywa.20.1667558281502; Fri, 04
 Nov 2022 03:38:01 -0700 (PDT)
MIME-Version: 1.0
References: <20221104103216.2576427-1-glider@google.com>
In-Reply-To: <20221104103216.2576427-1-glider@google.com>
From:   Alexander Potapenko <glider@google.com>
Date:   Fri, 4 Nov 2022 11:37:25 +0100
Message-ID: <CAG_fn=WhGa21EVCPNFp6BO3=CMzHFYNfwpXK+S0m6oxPr9xdrg@mail.gmail.com>
Subject: Re: [PATCH] ipv6: addrlabel: fix infoleak when sending struct
 ifaddrlblmsg to network
To:     glider@google.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        syzbot+3553517af6020c4f2813f1003fe76ef3cbffe98d@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> This patch ensures that the reserved field is always initialized.
>
> Reported-by: syzbot+3553517af6020c4f2813f1003fe76ef3cbffe98d@syzkaller.appspotmail.com

My bad, should be:
  Reported-by: syzbot+fa5414772d5c445dac3c@syzkaller.appspotmail.com
