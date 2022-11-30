Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B780363E09A
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229605AbiK3TVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiK3TU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:20:56 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9F383278
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:20:54 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id c15so11846564qtw.8
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QTqXUSUHOfSCHe+q8lEezcpVoHrYxPM2K46ADRFSg4Q=;
        b=rJe4KttveESN6bqLtat/sAagy0F4KKW/91TY5Ydc/Kx5uqZeIHwD6IGOYlJFqBqq/6
         LunTJYbb1hSAdwE1sAbhVcMu6fcw5v0xsuu2iaxasGbHxYAfhKBPKsejSeiyBE4UQMit
         AuOMboAwJEyJpltGCRqBLw8or294DF8LJ850s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QTqXUSUHOfSCHe+q8lEezcpVoHrYxPM2K46ADRFSg4Q=;
        b=1kr5PXfpDP/CxVjinPCLziABtlAM3L8fzOpvovxOdLMrYXGt8N6zpbo5VnBYRj7KAr
         /rgjwzDQgutXx7JxLrX2Z87uDDDbEp0QLoeo9omr50nv+tvJQCldJDyiZ6neemXaZmJ6
         LgZds0WsY0B/O3JCXd25LMIt7J/SSxhl/xtG5ofwryBzFbPNKMVXSI85iO0IN5nyDBQk
         P1gZ/56y8qqY4EQQYcvafzb86YgCcNEFJbyUHAHdEMxmmcTC8pcwVT0UJ+3mNa1ih/qz
         gMpdebNZOPacvSrnQvYO7aXZyVtkO/8+nmo03+MQ6+JFMwUng6PqxBtHxHCBgwCw2fH3
         FjHA==
X-Gm-Message-State: ANoB5pkhmnqg7FJplC/MDcsWiJxvv7PPMXizwf099O5bnMabc0kks81I
        BGbDQD3igudINxrD0f33quW30g==
X-Google-Smtp-Source: AA0mqf58g0O4rzxbrzoBvEk2vIch+NoFrco8tr2vUXCSmOlH0ZhRx1JSuW2Ezbdm9OJJupUeGrvUyA==
X-Received: by 2002:ac8:5ec8:0:b0:3a5:280d:31ff with SMTP id s8-20020ac85ec8000000b003a5280d31ffmr39265777qtx.646.1669836053521;
        Wed, 30 Nov 2022 11:20:53 -0800 (PST)
Received: from smtpclient.apple (c-73-148-104-166.hsd1.va.comcast.net. [73.148.104.166])
        by smtp.gmail.com with ESMTPSA id z18-20020ac87112000000b0039853b7b771sm1299541qto.80.2022.11.30.11.20.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 11:20:52 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Joel Fernandes <joel@joelfernandes.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH rcu 14/16] rxrpc: Use call_rcu_hurry() instead of call_rcu()
Date:   Wed, 30 Nov 2022 14:20:52 -0500
Message-Id: <B4935931-239F-4C48-9646-2C20578F027C@joelfernandes.org>
References: <639433.1669835344@warthog.procyon.org.uk>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>, rcu@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@meta.com,
        rostedt@goodmis.org, Marc Dionne <marc.dionne@auristor.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org
In-Reply-To: <639433.1669835344@warthog.procyon.org.uk>
To:     David Howells <dhowells@redhat.com>
X-Mailer: iPhone Mail (19G82)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 30, 2022, at 2:09 PM, David Howells <dhowells@redhat.com> wrote:
>=20
> =EF=BB=BFNote that this conflicts with my patch:

Oh.  I don=E2=80=99t see any review or Ack tags on it. Is it still under rev=
iew?

Thanks,

- Joel



>=20
>    rxrpc: Don't hold a ref for connection workqueue
>    https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/c=
ommit/?h=3Drxrpc-next&id=3D450b00011290660127c2d76f5c5ed264126eb229
>=20
> which should render it unnecessary.  It's a little ahead of yours in the
> net-next queue, if that means anything.
>=20
> David
>=20
