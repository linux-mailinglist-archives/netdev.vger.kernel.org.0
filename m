Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5B3683273
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 17:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbjAaQXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 11:23:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjAaQXL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 11:23:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C88C8A61
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 08:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675182146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gbg+AzhWEGt3wVxcWkSCdqk5Y0vGygpbNeSX8uKNpq0=;
        b=SU/wTffP2CV0rEo86iTYiTE9W2ZLo78CzuxpbECuKxErw7CqzjFwsGgWTSii/pnWKzd6V1
        k75PLlFEtr7wdsRvPiHjETZpsPvFmO8mu2AgbfZlidiY2X0VReTEYRz+FrBJbqa6axWUZM
        aWZZNWsj2ogkrcpQfVyS/8YBAKW6d00=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-589-Fv2Rc65CPOu2jz7u5xzgrQ-1; Tue, 31 Jan 2023 11:22:25 -0500
X-MC-Unique: Fv2Rc65CPOu2jz7u5xzgrQ-1
Received: by mail-vk1-f199.google.com with SMTP id l36-20020a056122202400b003e9f114f777so3586460vkd.10
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 08:22:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Gbg+AzhWEGt3wVxcWkSCdqk5Y0vGygpbNeSX8uKNpq0=;
        b=5UH87UnEKoNmcofFjbhLfnr68oD2I+24QQ8sbr2j7oLd+OOIkrczhmYgOhBreASWVr
         tNgpNQ2D2DJ+pKosY/lMAczvYfo80qRq58OsjqVDLpUiYSfza0lo+OrlUv39waTTpmN/
         E9BVcguU+cxK2bQ66b/CHmPRvXOQh6zc8efRC5i6WXjdmmPrd4Ni/YhI6D6QX3A8rLvC
         brbUqgIxKU8n2AXwkRtcqWMAU5yqWE+6MAADzTnYRNxwz2MHuINQVtI6lhebTsbOME0T
         2ISD2Vi4yZ9Wr9q3IiD/a8bA9afc0uQL+Buu1pGWJoQxxGn5KZXRwRtgM+92V62izyV3
         UN7g==
X-Gm-Message-State: AFqh2kqWyuAlcBuHAju5oQQB9mK9SQm/PD0TOhkLsJL3mOnfaRDdoN1q
        VSZaGhuFogQiSGyNtAgv8fZQ0R+xo70IDB6o02gybvJfh93g2r96TqEcwFtRMnyfCACYkr8F4uw
        2p2IZhQNjDea3sLoR
X-Received: by 2002:a05:6102:334c:b0:3c8:bfe0:d5ec with SMTP id j12-20020a056102334c00b003c8bfe0d5ecmr7530687vse.0.1675182140146;
        Tue, 31 Jan 2023 08:22:20 -0800 (PST)
X-Google-Smtp-Source: AMrXdXufopaXJrOQK8xf5PnImViVfo192XMgd8vmUeO5DkaGWebI8ksfnEA+4C/0qsZ9m08m5hlpTg==
X-Received: by 2002:a05:6102:334c:b0:3c8:bfe0:d5ec with SMTP id j12-20020a056102334c00b003c8bfe0d5ecmr7530665vse.0.1675182139834;
        Tue, 31 Jan 2023 08:22:19 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id 136-20020a37068e000000b00719d9f823c4sm7765895qkg.34.2023.01.31.08.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 08:22:19 -0800 (PST)
Message-ID: <17e062f077235b949090cba893c91f5637cc1f0e.camel@redhat.com>
Subject: Re: [PATCH v2 4/4] selftests: net: udpgso_bench_tx: Cater for
 pending datagrams zerocopy benchmarking
From:   Paolo Abeni <pabeni@redhat.com>
To:     Andrei Gherzan <andrei.gherzan@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 31 Jan 2023 17:22:16 +0100
In-Reply-To: <Y9kvADcYZ18XFTXu@qwirkle>
References: <20230131130412.432549-1-andrei.gherzan@canonical.com>
         <20230131130412.432549-4-andrei.gherzan@canonical.com>
         <d9ca623d01274889913001ce92f686652fa8fea8.camel@redhat.com>
         <Y9kvADcYZ18XFTXu@qwirkle>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-01-31 at 15:08 +0000, Andrei Gherzan wrote:
> On 23/01/31 03:51PM, Paolo Abeni wrote:
> > On Tue, 2023-01-31 at 13:04 +0000, Andrei Gherzan wrote:
> > > The test tool can check that the zerocopy number of completions value=
 is
> > > valid taking into consideration the number of datagram send calls. Th=
is can
> > > catch the system into a state where the datagrams are still in the sy=
stem
> > > (for example in a qdisk, waiting for the network interface to return =
a
> > > completion notification, etc).
> > >=20
> > > This change adds a retry logic of computing the number of completions=
 up to
> > > a configurable (via CLI) timeout (default: 2 seconds).
> > >=20
> > > Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
> > > ---
> > >  tools/testing/selftests/net/udpgso_bench_tx.c | 38 +++++++++++++++--=
--
> > >  1 file changed, 30 insertions(+), 8 deletions(-)
> > >=20
> > > diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/te=
sting/selftests/net/udpgso_bench_tx.c
> > > index b47b5c32039f..5a29b5f24023 100644
> > > --- a/tools/testing/selftests/net/udpgso_bench_tx.c
> > > +++ b/tools/testing/selftests/net/udpgso_bench_tx.c
> > > @@ -62,6 +62,7 @@ static int	cfg_payload_len	=3D (1472 * 42);
> > >  static int	cfg_port	=3D 8000;
> > >  static int	cfg_runtime_ms	=3D -1;
> > >  static bool	cfg_poll;
> > > +static int	cfg_poll_loop_timeout_ms =3D 2000;
> > >  static bool	cfg_segment;
> > >  static bool	cfg_sendmmsg;
> > >  static bool	cfg_tcp;
> > > @@ -235,16 +236,17 @@ static void flush_errqueue_recv(int fd)
> > >  	}
> > >  }
> > > =20
> > > -static void flush_errqueue(int fd, const bool do_poll)
> > > +static void flush_errqueue(int fd, const bool do_poll,
> > > +		unsigned long poll_timeout, const bool poll_err)
> > >  {
> > >  	if (do_poll) {
> > >  		struct pollfd fds =3D {0};
> > >  		int ret;
> > > =20
> > >  		fds.fd =3D fd;
> > > -		ret =3D poll(&fds, 1, 500);
> > > +		ret =3D poll(&fds, 1, poll_timeout);
> > >  		if (ret =3D=3D 0) {
> > > -			if (cfg_verbose)
> > > +			if ((cfg_verbose) && (poll_err))
> > >  				fprintf(stderr, "poll timeout\n");
> > >  		} else if (ret < 0) {
> > >  			error(1, errno, "poll");
> > > @@ -254,6 +256,22 @@ static void flush_errqueue(int fd, const bool do=
_poll)
> > >  	flush_errqueue_recv(fd);
> > >  }
> > > =20
> > > +static void flush_errqueue_retry(int fd, const bool do_poll, unsigne=
d long num_sends)
> > > +{
> > > +	unsigned long tnow, tstop;
> > > +	bool first_try =3D true;
> > > +
> > > +	tnow =3D gettimeofday_ms();
> > > +	tstop =3D tnow + cfg_poll_loop_timeout_ms;
> > > +	do {
> > > +		flush_errqueue(fd, do_poll, tstop - tnow, first_try);
> > > +		first_try =3D false;
> > > +		if (!do_poll)
> > > +			usleep(1000);  // a throttling delay if polling is enabled
> >=20
> > Even if the kernel codying style is not very strictly enforced for
> > self-tests, please avoid c++ style comments.
> >=20
> > More importantly, as Willem noded, this function is always called with
> > do_poll =3D=3D true. You should drop such argument and the related bran=
ch
> > above.
>=20
> Agreed. I will drop.
>=20
> >=20
> > > +		tnow =3D gettimeofday_ms();
> > > +	} while ((stat_zcopies !=3D num_sends) && (tnow < tstop));
> > > +}
> > > +
> > >  static int send_tcp(int fd, char *data)
> > >  {
> > >  	int ret, done =3D 0, count =3D 0;
> > > @@ -413,8 +431,9 @@ static int send_udp_segment(int fd, char *data)
> > > =20
> > >  static void usage(const char *filepath)
> > >  {
> > > -	error(1, 0, "Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l sec=
s] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]",
> > > -		    filepath);
> > > +	error(1, 0,
> > > +			"Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] [-L sec=
s] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]",
> > > +			filepath);
> >=20
> > Please avoid introducing unnecessary white-space changes (no reason to
> > move the usage text on a new line)
>=20
> The only reason why I've done this was to make scripts/checkpatch.pl
> happy:
>=20
> WARNING: line length of 141 exceeds 100 columns
> #83: FILE: tools/testing/selftests/net/udpgso_bench_tx.c:432:
>=20
> I can drop and ignore the warning, or maybe it would have been better to
> just mention this in git message. What do you prefer?

Long lines are allowed for (kernel) messages, to make them easily grep-
able.

In this specific case you can either append the new text to the message
without introducing that strange indentation or even better break the
usage string alike:

	"Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] [-L secs]"
	" [-L secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]"

Cheers,

Paolo

