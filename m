Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7581E66DC14
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 12:16:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236814AbjAQLQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 06:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236852AbjAQLQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 06:16:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2912384E
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 03:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673954089;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nZmHQlRdGLmMiq6W5if2O2O6948Uerv8yyVbiiAO0fg=;
        b=GW96iWFoZRzfyE6MuIhEoqKhsjdGPlmbL2mOB6J5KTByb+Mr+GFNrDn/9fXTVtyU19Ile+
        6lesXvX3tYYO/S/w5zYnMqSCms4khgKF3SJiARUJH6xWdej20Q/FkscZNHRT4q6VL1AgVH
        yHVoTtZKksxuOsYkpXbAHKLsXZfvejw=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-655-89DRPlpcMOuNyw6trV-GwA-1; Tue, 17 Jan 2023 06:14:48 -0500
X-MC-Unique: 89DRPlpcMOuNyw6trV-GwA-1
Received: by mail-qk1-f200.google.com with SMTP id bi3-20020a05620a318300b00702545f73d5so22389837qkb.8
        for <netdev@vger.kernel.org>; Tue, 17 Jan 2023 03:14:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nZmHQlRdGLmMiq6W5if2O2O6948Uerv8yyVbiiAO0fg=;
        b=IaCIjehjS+whiytZunOQLWQOhTZXPB4HBIy3lW2NVXYBcfgsAxC1oatlcvVGSR0jFC
         HCERF0AJbnkKXoc5Cvlj6cf0k9FcpzHkkmDXLKalA7FaqKN7nPY55H7DmT6a44HeFddv
         pFhx1WBjNyZvSPCYzydNlbrxnYFS+DoZ6dAaUHw15M7MyaBOmOPmBPP1ZFs6torzpLs6
         IYgbTrztrjgHTiQFgODLlPr6A+O7K7a8O0YNRtWCJ5RB/Kkt3Aq9s6C8nw7iMlxcRCFR
         2GD5NjiayhjYcIhDP4hNpCPYOSTRppxClaAcnhm4pdRi9NPGjlX62HdZSFYN1oIv3f/L
         tVHA==
X-Gm-Message-State: AFqh2kppBZGdSF+GuWA9JdZNH+dfGhLsfmJbBwDPMVsqorF5N+n7h95L
        ZvQAo+/VmFO5XSAq6C2QNTTnstpUj5PeLagzMFXprcbJgtfcx2zc1hGrw/Gpg2E52rMx1/aoBtD
        2zG7aDpMkAbBFoI7x
X-Received: by 2002:a05:6214:5c84:b0:534:b2be:d226 with SMTP id lj4-20020a0562145c8400b00534b2bed226mr3816038qvb.20.1673954087647;
        Tue, 17 Jan 2023 03:14:47 -0800 (PST)
X-Google-Smtp-Source: AMrXdXtpnh13zWO+ij6ysgGXoV6p3xCCsh/hZBvy1P0VcWQE+PWqNdDbJOZaHzodmB/0MLbuKC1ryA==
X-Received: by 2002:a05:6214:5c84:b0:534:b2be:d226 with SMTP id lj4-20020a0562145c8400b00534b2bed226mr3816019qvb.20.1673954087351;
        Tue, 17 Jan 2023 03:14:47 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-115-179.dyn.eolo.it. [146.241.115.179])
        by smtp.gmail.com with ESMTPSA id c23-20020a05620a269700b006fb11eee465sm20294931qkp.64.2023.01.17.03.14.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 03:14:46 -0800 (PST)
Message-ID: <90a213180cdc9792dfaf5271ea4e61fc07573f0d.camel@redhat.com>
Subject: Re: [PATCH net-next] ipv6: fix reachability confirmation with
 proxy_ndp
From:   Paolo Abeni <pabeni@redhat.com>
To:     Gergely =?ISO-8859-1?Q?Risk=F3?= <gergely.risko@gmail.com>,
        netdev@vger.kernel.org
Cc:     yoshfuji@linux-ipv6.org, edumazet@google.com, davem@davemloft.net,
        dsahern@kernel.org, Jakub Kicinski <kuba@kernel.org>
Date:   Tue, 17 Jan 2023 12:14:44 +0100
In-Reply-To: <CAMhZOOx3fnS6VtU5iKcyN7jAULG5ghRmTJYu8FaOYfkjpo2-XQ@mail.gmail.com>
References: <20230114185243.3265491-1-gergely.risko@gmail.com>
         <20230116205320.155f58be@kernel.org>
         <CAMhZOOx3fnS6VtU5iKcyN7jAULG5ghRmTJYu8FaOYfkjpo2-XQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, 2023-01-17 at 11:29 +0100, Gergely Risk=C3=B3 wrote:
> (resent to the mailing list too without stupid default Gmail HTML, sorry)
>=20
> On Tue, Jan 17, 2023 at 5:53 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > Is this a regression? Did it use to work at any point in time?
>=20
> Yes, this is a regression.
>=20
> Here is the proof from 2020: https://github.com/lxc/lxd/issues/6668
>=20
> Here people discuss that the multicast part works after setting
> /proc/sys/net/ipv6/conf/eth0/proxy_ndp, but the unicast part only
> works if they set conf/all/proxy_ndp.
>=20
> So there was a point in time when the unicast worked. :)
>=20
> The inconsistency regarding all/eth0 with multicast/unicast, I plan to
> address in a separate patch, but I still need to do my homework
> regarding that (more code reading), to make sure that I'm
> understanding the context and the original intention enough.
>=20
> The regression was introduced by Kangmin Park, as kindly pointed out
> by David Ahern.  In my opinion they ran into this regression, because
> they were just looking for places, where finalization statements were
> not properly replicated in front of return statements.  At least there
> is no proper explanation in the regression introducing code.
>=20
> That's why this time I added a big comment in the hopes of protecting
> ourselves in the future.
>=20
> > We need to decide whether it needs to be sent for 6.1 and stable.
> > If not we should soften the language (specifically remove the "fix"
> > from the subject) otherwise the always-eager stable team will pull
> > it into stable anyway :|
>=20
> I tried to read up on all the requirements as much as possible, but
> yes, I'm a first time committer, and it shows :(
>=20
> I was thinking that this is non-urgent, as it's been like this since
> 2021, and people although complain on the internet, but not enough to
> actually do something about it, and it looked like that the logic is
> "next is free", "6.1 needs to have reasons", so I decided to chicken
> out and go for next.  If in the current form the patch can be sent for
> 6.1 and stable, I would prefer that, as I currently have to compile my
> own kernel with this patch in my production system and it is a
> regression after all... :)
>=20
> > Also - you haven't CCed the mailing list, you need to do so for
> > the patch to be applied.
>=20
> Yes, another noob mistake, the first point where as a new person I
> found out about this, is when I sent to the mailing list ONLY, and in
> the CI/CD I got the error message that I should CC the maintainers.
> The proper list of email addresses to copy-paste to the git send-email
> command is not published before you make a mistake.  At that point if
> I send the mailing list again, then the patch duplicates in patchwork,
> so I decided to just mail the maintainers separately, probably I
> should have came up with a better way...
>=20
> My next patch will be all better.  Do you prefer to reject this and
> then I can resend the whole thing the proper way (fixing typos/grammar
> too in the comments and commit message)?

Thank you for the detailed explanation.

I think it's better if you repost this (for net), so we keep the
process clean. You can (and should) retain the reviewed-by tag by David
A., including it into the SoB area.

Cheers,

Paolo

