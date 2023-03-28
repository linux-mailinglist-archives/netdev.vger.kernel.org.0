Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DFE26CC998
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 19:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjC1RsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 13:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjC1RsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 13:48:16 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A36FCDD2
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 10:48:15 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id h11so6721274ild.11
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 10:48:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680025695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5izyb6agMs75eRv0ynnnq+JA37sgUajUogKjnK8qAZI=;
        b=OlA5pER6r24oXi7I5fjbfS5804H0/W3cnQEXG5ugGJALwhY5F/IYCpcDxCTmNjZRPI
         2f2zanunoRZxeZ9rb+Hd/tA9ATEvNoYHeVfKo8VEh7dH+OP1czkENSjkFG6KuR9FLXd/
         J+BIJwXjbhM7TsDuG/hW7fEyj3yruzVnRRSb+UqQQLU9L//fdnMwSo5EDpGA9wJfI0N6
         aP15dHwkDRTk+Fm6Yo9T+pQsPGbXqAdBteBtCHB42ZzkPghohy0jx/42g3EjSCGPa0s4
         eD/N5Lyi1AtShQ3Awfw0RILWbk4FIyjF99dtZuLmMU6PjRUrLLCu6o0tm2WO4h3KcEC/
         +27A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680025695;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5izyb6agMs75eRv0ynnnq+JA37sgUajUogKjnK8qAZI=;
        b=ol6EKyF7/vd07QnVplut42I9vV0EqIRldX1HpuW/2rJOTnYZV7ZvrPUHP8D7Rw8gES
         ZhnB4w5x/r7EWFeuZN2GTkFEYnUX2f9yoPIVTAR+72nP4AKOpV76vYNsZDeKBIKgZdrG
         noT/QzHft1CxB3TNH8NsHyDPL3BAeARa32FvWbBSRsVw2qiSI6Twa1y3sYZb8txF/JR5
         WUwMbHkjgAOj47WthS3beF44PL16U9bA6QfFPLLqnCPA2awVEQ+yZ28aUL1KrwJsuSu1
         ceKHYb2o7MBsqUtwbS7HTU9fO12T5lj+BiRVSXA/rQwgJFy9FfUSdRqCkb1IOBXBxjC+
         dPcQ==
X-Gm-Message-State: AAQBX9dOqS9BtkQsWvG++0SdbBnrd3W/2pNna3DXq00+3yLN1ekbfjBN
        xpsoHD7DW1OsUKdZUflQlOve6ONzGt4S+ufqLmd9hQ==
X-Google-Smtp-Source: AKy350ZBetPPlEi7u4x0PvYpnTkziSQf38+agCQhFCFNIsbhBP64uDsvE6PjdsousRm94gjf69caiAymcFQblrB0VCk=
X-Received: by 2002:a05:6e02:1bef:b0:322:fe4d:d60 with SMTP id
 y15-20020a056e021bef00b00322fe4d0d60mr8915000ilv.2.1680025694607; Tue, 28 Mar
 2023 10:48:14 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iLF6_iUd6DSbrqALSvowPfNKqnOrX27GpVPLSCG-FipCA@mail.gmail.com>
 <20230328164119.44065-1-kuniyu@amazon.com>
In-Reply-To: <20230328164119.44065-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 28 Mar 2023 19:48:03 +0200
Message-ID: <CANn89iKxEwUq8NSHuPmF89LB6mboj9v6+94b0wikoDohsNTrLg@mail.gmail.com>
Subject: Re: [PATCH v1 net] tcp: Refine SYN handling for PAWS.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kuni1840@gmail.com,
        netdev@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 6:41=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.co=
m> wrote:

> I see.
> Should I replace the tag with add 'CC: stable # backport ver', or
> respin for net-next without the tag ?

Yes, net-next should be a better target I think, but no hard feelings
if this makes your life easier.
