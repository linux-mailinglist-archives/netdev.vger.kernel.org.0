Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FA7683526
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 19:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbjAaS1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 13:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbjAaS1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 13:27:07 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 405EF3EFC6
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 10:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675189591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tPVr9VQU03eEXhGeiXbAtJeJqwMDVcfzCgJzhcu/FKQ=;
        b=PjX8jO6i9vgN4x1HcbMwX0m1vMa7NKNFR3SAU6pP6lex1B/PdTNgDOlTV1wKi9FCReOmUx
        5bk15yKGxEXUjoE++Bdgze/hLEZe7e6WfXtE8Cf+BYbATakjZThuSFTjiOm764UT8lZR5P
        Wl6jVmtn+MlBGn3Qu1JP7mwBO2Xuxgc=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-487-BAeQ2OYrP7upwcZC87y7bQ-1; Tue, 31 Jan 2023 13:26:29 -0500
X-MC-Unique: BAeQ2OYrP7upwcZC87y7bQ-1
Received: by mail-qt1-f197.google.com with SMTP id i5-20020ac813c5000000b003b86b748aadso3094008qtj.14
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 10:26:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tPVr9VQU03eEXhGeiXbAtJeJqwMDVcfzCgJzhcu/FKQ=;
        b=GsFce1ioZtyTG4LtipvteZJHT8qAT3v/v53iP4C592QHc4OWvGwdNha8z/5DDf0B7I
         NMLLI6jC/v0LOGmgKv/78WN7y3Aj/VKvI3ziXEbC305Drm9dojQfxbjZbmH5Q+XVpoXc
         XeP5RjG5i/H41Yu67npr3DGDXrDbKT7k4XGKPss/Bg0OHGlRMrUE87AjVePYegHMxw1d
         P5ErY/mLezUaerjFMwpW4QWBLZkDRxPNOoneBliGpjJ2lGMwApSu8Iquhh+PEJ3UmqYC
         LOfEw4oDVFGVTWRgYyzwf/Zr/1/0UTtr8qNJ0Tu2RIgrP0dPH1wrn+utfjx5/zHesTvq
         E5+g==
X-Gm-Message-State: AO0yUKUsks/w2oaCN/OppvW/Q1GHdaFVC2rgoMx15DtffQDvSWHwTTIA
        za5GIZW4nYUuPRHeBjz3odedRrH+VqfJ25NmnH0PQx3j5DuuNoQAtnmzLJseCWBfQbIVSGPvTMZ
        6O0HxoaeBhCzQbP9L
X-Received: by 2002:ac8:550a:0:b0:3b8:6d44:ca7e with SMTP id j10-20020ac8550a000000b003b86d44ca7emr5494711qtq.4.1675189589250;
        Tue, 31 Jan 2023 10:26:29 -0800 (PST)
X-Google-Smtp-Source: AK7set/erd8DGEec+uC8MBs3TmM38Y0xZXmeSbm8CsnlfLum7slDnCe96fqRFdeXFk8v8JRTLdgYcA==
X-Received: by 2002:ac8:550a:0:b0:3b8:6d44:ca7e with SMTP id j10-20020ac8550a000000b003b86d44ca7emr5494682qtq.4.1675189588957;
        Tue, 31 Jan 2023 10:26:28 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-113-28.dyn.eolo.it. [146.241.113.28])
        by smtp.gmail.com with ESMTPSA id k14-20020ac8604e000000b003ab7aee56a0sm10161085qtm.39.2023.01.31.10.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 10:26:28 -0800 (PST)
Message-ID: <58cefd5871c4901a6f9c0394891637fed170bb47.camel@redhat.com>
Subject: Re: [PATCH v2 4/4] selftests: net: udpgso_bench_tx: Cater for
 pending datagrams zerocopy benchmarking
From:   Paolo Abeni <pabeni@redhat.com>
To:     Andrei Gherzan <andrei.gherzan@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 31 Jan 2023 19:26:25 +0100
In-Reply-To: <Y9lCYT3XUgo4npox@qwirkle>
References: <20230131130412.432549-1-andrei.gherzan@canonical.com>
         <20230131130412.432549-4-andrei.gherzan@canonical.com>
         <d9ca623d01274889913001ce92f686652fa8fea8.camel@redhat.com>
         <Y9kvADcYZ18XFTXu@qwirkle>
         <17e062f077235b949090cba893c91f5637cc1f0e.camel@redhat.com>
         <Y9lCYT3XUgo4npox@qwirkle>
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

On Tue, 2023-01-31 at 16:31 +0000, Andrei Gherzan wrote:
> On 23/01/31 05:22PM, Paolo Abeni wrote:
> > On Tue, 2023-01-31 at 15:08 +0000, Andrei Gherzan wrote:
> > > On 23/01/31 03:51PM, Paolo Abeni wrote:
> > > > On Tue, 2023-01-31 at 13:04 +0000, Andrei Gherzan wrote:
> > > > > The test tool can check that the zerocopy number of completions v=
alue is
> > > > > valid taking into consideration the number of datagram send calls=
. This can
> > > > > catch the system into a state where the datagrams are still in th=
e system
> > > > > (for example in a qdisk, waiting for the network interface to ret=
urn a
> > > > > completion notification, etc).
> > > > >=20
> > > > > This change adds a retry logic of computing the number of complet=
ions up to
> > > > > a configurable (via CLI) timeout (default: 2 seconds).
> > > > >=20
> > > > > Signed-off-by: Andrei Gherzan <andrei.gherzan@canonical.com>
> > > > > ---
> > > > >  tools/testing/selftests/net/udpgso_bench_tx.c | 38 +++++++++++++=
++----
> > > > >  1 file changed, 30 insertions(+), 8 deletions(-)
> > > > >=20
> > > > > diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tool=
s/testing/selftests/net/udpgso_bench_tx.c
> > > > > index b47b5c32039f..5a29b5f24023 100644
> > > > > --- a/tools/testing/selftests/net/udpgso_bench_tx.c
> > > > > +++ b/tools/testing/selftests/net/udpgso_bench_tx.c
> > > > > @@ -62,6 +62,7 @@ static int	cfg_payload_len	=3D (1472 * 42);
> > > > >  static int	cfg_port	=3D 8000;
> > > > >  static int	cfg_runtime_ms	=3D -1;
> > > > >  static bool	cfg_poll;
> > > > > +static int	cfg_poll_loop_timeout_ms =3D 2000;
> > > > >  static bool	cfg_segment;
> > > > >  static bool	cfg_sendmmsg;
> > > > >  static bool	cfg_tcp;
> > > > > @@ -235,16 +236,17 @@ static void flush_errqueue_recv(int fd)
> > > > >  	}
> > > > >  }
> > > > > =20
> > > > > -static void flush_errqueue(int fd, const bool do_poll)
> > > > > +static void flush_errqueue(int fd, const bool do_poll,
> > > > > +		unsigned long poll_timeout, const bool poll_err)
> > > > >  {
> > > > >  	if (do_poll) {
> > > > >  		struct pollfd fds =3D {0};
> > > > >  		int ret;
> > > > > =20
> > > > >  		fds.fd =3D fd;
> > > > > -		ret =3D poll(&fds, 1, 500);
> > > > > +		ret =3D poll(&fds, 1, poll_timeout);
> > > > >  		if (ret =3D=3D 0) {
> > > > > -			if (cfg_verbose)
> > > > > +			if ((cfg_verbose) && (poll_err))
> > > > >  				fprintf(stderr, "poll timeout\n");
> > > > >  		} else if (ret < 0) {
> > > > >  			error(1, errno, "poll");
> > > > > @@ -254,6 +256,22 @@ static void flush_errqueue(int fd, const boo=
l do_poll)
> > > > >  	flush_errqueue_recv(fd);
> > > > >  }
> > > > > =20
> > > > > +static void flush_errqueue_retry(int fd, const bool do_poll, uns=
igned long num_sends)
> > > > > +{
> > > > > +	unsigned long tnow, tstop;
> > > > > +	bool first_try =3D true;
> > > > > +
> > > > > +	tnow =3D gettimeofday_ms();
> > > > > +	tstop =3D tnow + cfg_poll_loop_timeout_ms;
> > > > > +	do {
> > > > > +		flush_errqueue(fd, do_poll, tstop - tnow, first_try);
> > > > > +		first_try =3D false;
> > > > > +		if (!do_poll)
> > > > > +			usleep(1000);  // a throttling delay if polling is enabled
> > > >=20
> > > > Even if the kernel codying style is not very strictly enforced for
> > > > self-tests, please avoid c++ style comments.
> > > >=20
> > > > More importantly, as Willem noded, this function is always called w=
ith
> > > > do_poll =3D=3D true. You should drop such argument and the related =
branch
> > > > above.
> > >=20
> > > Agreed. I will drop.
> > >=20
> > > >=20
> > > > > +		tnow =3D gettimeofday_ms();
> > > > > +	} while ((stat_zcopies !=3D num_sends) && (tnow < tstop));
> > > > > +}
> > > > > +
> > > > >  static int send_tcp(int fd, char *data)
> > > > >  {
> > > > >  	int ret, done =3D 0, count =3D 0;
> > > > > @@ -413,8 +431,9 @@ static int send_udp_segment(int fd, char *dat=
a)
> > > > > =20
> > > > >  static void usage(const char *filepath)
> > > > >  {
> > > > > -	error(1, 0, "Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l=
 secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]",
> > > > > -		    filepath);
> > > > > +	error(1, 0,
> > > > > +			"Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] [-L=
 secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]",
> > > > > +			filepath);
> > > >=20
> > > > Please avoid introducing unnecessary white-space changes (no reason=
 to
> > > > move the usage text on a new line)
> > >=20
> > > The only reason why I've done this was to make scripts/checkpatch.pl
> > > happy:
> > >=20
> > > WARNING: line length of 141 exceeds 100 columns
> > > #83: FILE: tools/testing/selftests/net/udpgso_bench_tx.c:432:
> > >=20
> > > I can drop and ignore the warning, or maybe it would have been better=
 to
> > > just mention this in git message. What do you prefer?
> >=20
> > Long lines are allowed for (kernel) messages, to make them easily grep-
> > able.
> >=20
> > In this specific case you can either append the new text to the message
> > without introducing that strange indentation or even better break the
> > usage string alike:
> >=20
> > 	"Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] [-L secs]"
> > 	" [-L secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]"
>=20
> Funny I went through this too but it also fails with:
>=20
> WARNING: quoted string split across lines
> #84: FILE: tools/testing/selftests/net/udpgso_bench_tx.c:433
>=20
> This is how I usually do it but it seems like it's flagged too.

I'm all for ignoring this warning in this specific context. Among other
things it will be consistent with other existing self-tests.

Eventually the checkpatch script could be tuned (with an unrelated
patch) to discriminate between kernel and self-tests code.

Cheers,

Paolo

