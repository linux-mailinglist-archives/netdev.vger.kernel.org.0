Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2561605A
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 11:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726805AbfEGJQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 05:16:11 -0400
Received: from mail.katalix.com ([82.103.140.233]:48113 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726798AbfEGJQK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 May 2019 05:16:10 -0400
X-Greylist: delayed 330 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 May 2019 05:16:08 EDT
Received: from localhost (82-69-49-219.dsl.in-addr.zen.co.uk [82.69.49.219])
        (Authenticated sender: tom)
        by mail.katalix.com (Postfix) with ESMTPSA id 776D3BC821;
        Tue,  7 May 2019 10:10:35 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=katalix.com; s=mail;
        t=1557220235; bh=RSfMNPqTQc3cr0GQ+yyZsRK0XvXnC44GQn5BoIm9Thw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=0BCO09wgjKUE90bSy/P3dLLs4I3BxhTpnyGR81cA99IBgHylfoZnpjb0CJXgGjdNi
         xH/3EoOQ3WLkqX4GELBDWPD5ff3o22Eg+vebrtX4XSHAT1Erbwzlwp/grb3luukeyJ
         Gp64QsIzBrrqhrthV6rcCWf0HMsVFyjsXnAacpvI=
Date:   Tue, 7 May 2019 10:10:34 +0100
From:   Tom Parkin <tparkin@katalix.com>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     linux-ppp@vger.kernel.org, netdev@vger.kernel.org,
        Paul Mackerras <paulus@ozlabs.org>,
        Jo-Philipp Wich <jo@mein.io>
Subject: Re: [PATCH pppd v4] pppoe: custom host-uniq tag
Message-ID: <20190507091034.GA3561@jackdaw>
References: <20190504164853.4736-1-mcroce@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <20190504164853.4736-1-mcroce@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matteo,

On Sat, May 04, 2019 at 06:48:53PM +0200, Matteo Croce wrote:
> Add pppoe 'host-uniq' option to set an arbitrary
> host-uniq tag instead of the pppd pid.
> Some ISPs use such tag to authenticate the CPE,
> so it must be set to a proper value to connect.
>=20
> Signed-off-by: Matteo Croce <mcroce@redhat.com>
> Signed-off-by: Jo-Philipp Wich <jo@mein.io>
> ---
>  pppd/plugins/rp-pppoe/common.c          | 14 +++----
>  pppd/plugins/rp-pppoe/discovery.c       | 52 ++++++++++---------------
>  pppd/plugins/rp-pppoe/plugin.c          | 15 ++++++-
>  pppd/plugins/rp-pppoe/pppoe-discovery.c | 41 ++++++++++++-------
>  pppd/plugins/rp-pppoe/pppoe.h           | 30 +++++++++++++-
>  5 files changed, 96 insertions(+), 56 deletions(-)
>=20
> diff --git a/pppd/plugins/rp-pppoe/common.c b/pppd/plugins/rp-pppoe/commo=
n.c
> index 89c633c..8f175ec 100644
> --- a/pppd/plugins/rp-pppoe/common.c
> +++ b/pppd/plugins/rp-pppoe/common.c
> @@ -119,15 +119,11 @@ sendPADT(PPPoEConnection *conn, char const *msg)
>      conn->session =3D 0;
> =20
>      /* If we're using Host-Uniq, copy it over */
> -    if (conn->useHostUniq) {
> -	PPPoETag hostUniq;
> -	pid_t pid =3D getpid();
> -	hostUniq.type =3D htons(TAG_HOST_UNIQ);
> -	hostUniq.length =3D htons(sizeof(pid));
> -	memcpy(hostUniq.payload, &pid, sizeof(pid));
> -	memcpy(cursor, &hostUniq, sizeof(pid) + TAG_HDR_SIZE);
> -	cursor +=3D sizeof(pid) + TAG_HDR_SIZE;
> -	plen +=3D sizeof(pid) + TAG_HDR_SIZE;
> +    if (conn->hostUniq.length) {
> +	int len =3D ntohs(conn->hostUniq.length);
> +	memcpy(cursor, &conn->hostUniq, len + TAG_HDR_SIZE);
> +	cursor +=3D len + TAG_HDR_SIZE;
> +	plen +=3D len + TAG_HDR_SIZE;
>      }
> =20
>      /* Copy error message */
> diff --git a/pppd/plugins/rp-pppoe/discovery.c b/pppd/plugins/rp-pppoe/di=
scovery.c
> index 04877cb..16a59f7 100644
> --- a/pppd/plugins/rp-pppoe/discovery.c
> +++ b/pppd/plugins/rp-pppoe/discovery.c
> @@ -80,14 +80,10 @@ static void
>  parseForHostUniq(UINT16_t type, UINT16_t len, unsigned char *data,
>  		 void *extra)
>  {
> -    int *val =3D (int *) extra;
> -    if (type =3D=3D TAG_HOST_UNIQ && len =3D=3D sizeof(pid_t)) {
> -	pid_t tmp;
> -	memcpy(&tmp, data, len);
> -	if (tmp =3D=3D getpid()) {
> -	    *val =3D 1;
> -	}
> -    }
> +    PPPoETag *tag =3D extra;
> +
> +    if (type =3D=3D TAG_HOST_UNIQ && len =3D=3D ntohs(tag->length))
> +	tag->length =3D memcmp(data, tag->payload, len);
>  }
> =20
>  /**********************************************************************
> @@ -104,16 +100,16 @@ parseForHostUniq(UINT16_t type, UINT16_t len, unsig=
ned char *data,
>  static int
>  packetIsForMe(PPPoEConnection *conn, PPPoEPacket *packet)
>  {
> -    int forMe =3D 0;
> +    PPPoETag hostUniq =3D conn->hostUniq;
> =20
>      /* If packet is not directed to our MAC address, forget it */
>      if (memcmp(packet->ethHdr.h_dest, conn->myEth, ETH_ALEN)) return 0;
> =20
>      /* If we're not using the Host-Unique tag, then accept the packet */
> -    if (!conn->useHostUniq) return 1;
> +    if (!conn->hostUniq.length) return 1;
> =20
> -    parsePacket(packet, parseForHostUniq, &forMe);
> -    return forMe;
> +    parsePacket(packet, parseForHostUniq, &hostUniq);
> +    return !hostUniq.length;
>  }
> =20
>  /**********************************************************************
> @@ -301,16 +297,12 @@ sendPADI(PPPoEConnection *conn)
>      }
> =20
>      /* If we're using Host-Uniq, copy it over */
> -    if (conn->useHostUniq) {
> -	PPPoETag hostUniq;
> -	pid_t pid =3D getpid();
> -	hostUniq.type =3D htons(TAG_HOST_UNIQ);
> -	hostUniq.length =3D htons(sizeof(pid));
> -	memcpy(hostUniq.payload, &pid, sizeof(pid));
> -	CHECK_ROOM(cursor, packet.payload, sizeof(pid) + TAG_HDR_SIZE);
> -	memcpy(cursor, &hostUniq, sizeof(pid) + TAG_HDR_SIZE);
> -	cursor +=3D sizeof(pid) + TAG_HDR_SIZE;
> -	plen +=3D sizeof(pid) + TAG_HDR_SIZE;
> +    if (conn->hostUniq.length) {
> +	int len =3D ntohs(conn->hostUniq.length);
> +	CHECK_ROOM(cursor, packet.payload, len + TAG_HDR_SIZE);
> +	memcpy(cursor, &conn->hostUniq, len + TAG_HDR_SIZE);
> +	cursor +=3D len + TAG_HDR_SIZE;
> +	plen +=3D len + TAG_HDR_SIZE;
>      }
>

This change recently caused breakage for us in a test environment when
we updated to Ubuntu Bionic for some of the test VMs.  Bionic picks up
this patch:

https://sources.debian.org/patches/ppp/2.4.7-1+4/pr-28-pppoe-custom-host-un=
iq-tag.patch/

Previously, pppd would send a Host-Uniq tag by default, since
PPPOEInitDevice would set conn->useHostUniq to 1, and nothing ever
changed it from that default value.

With this change the logic is different: Host-Uniq will only be sent
if the user supplies the tag content as a part of the pppd command
line arguments.

This mattered in our test environment since we were using a single
host to instantiate multiple PPPoE connections for stress-testing
purposes.  The change from "default Host-Uniq on" to "default
Host-Uniq off" broke that environment since the PPPoE server could no
longer distinguish between the client pppd processes.

Whether or not this change would matter outside our test env I'm not
sure.  But I wonder whether this change could be made while retaining
the "default Host-Uniq on" behaviour?

>      /* Add our maximum MTU/MRU */
> @@ -478,16 +470,12 @@ sendPADR(PPPoEConnection *conn)
>      cursor +=3D namelen + TAG_HDR_SIZE;
> =20
>      /* If we're using Host-Uniq, copy it over */
> -    if (conn->useHostUniq) {
> -	PPPoETag hostUniq;
> -	pid_t pid =3D getpid();
> -	hostUniq.type =3D htons(TAG_HOST_UNIQ);
> -	hostUniq.length =3D htons(sizeof(pid));
> -	memcpy(hostUniq.payload, &pid, sizeof(pid));
> -	CHECK_ROOM(cursor, packet.payload, sizeof(pid)+TAG_HDR_SIZE);
> -	memcpy(cursor, &hostUniq, sizeof(pid) + TAG_HDR_SIZE);
> -	cursor +=3D sizeof(pid) + TAG_HDR_SIZE;
> -	plen +=3D sizeof(pid) + TAG_HDR_SIZE;
> +    if (conn->hostUniq.length) {
> +	int len =3D ntohs(conn->hostUniq.length);
> +	CHECK_ROOM(cursor, packet.payload, len+TAG_HDR_SIZE);
> +	memcpy(cursor, &conn->hostUniq, len + TAG_HDR_SIZE);
> +	cursor +=3D len + TAG_HDR_SIZE;
> +	plen +=3D len + TAG_HDR_SIZE;
>      }
> =20
>      /* Add our maximum MTU/MRU */
> diff --git a/pppd/plugins/rp-pppoe/plugin.c b/pppd/plugins/rp-pppoe/plugi=
n.c
> index c89be94..966be15 100644
> --- a/pppd/plugins/rp-pppoe/plugin.c
> +++ b/pppd/plugins/rp-pppoe/plugin.c
> @@ -68,6 +68,7 @@ static char *existingSession =3D NULL;
>  static int printACNames =3D 0;
>  static char *pppoe_reqd_mac =3D NULL;
>  unsigned char pppoe_reqd_mac_addr[6];
> +static char *host_uniq;
> =20
>  static int PPPoEDevnameHook(char *cmd, char **argv, int doit);
>  static option_t Options[] =3D {
> @@ -85,6 +86,8 @@ static option_t Options[] =3D {
>        "Be verbose about discovered access concentrators"},
>      { "pppoe-mac", o_string, &pppoe_reqd_mac,
>        "Only connect to specified MAC address" },
> +    { "host-uniq", o_string, &host_uniq,
> +      "Set the Host-Uniq to the supplied hex string" },
>      { NULL }
>  };
>  int (*OldDevnameHook)(char *cmd, char **argv, int doit) =3D NULL;
> @@ -110,7 +113,6 @@ PPPOEInitDevice(void)
>      conn->ifName =3D devnam;
>      conn->discoverySocket =3D -1;
>      conn->sessionSocket =3D -1;
> -    conn->useHostUniq =3D 1;
>      conn->printACNames =3D printACNames;
>      conn->discoveryTimeout =3D PADI_TIMEOUT;
>      return 1;
> @@ -166,6 +168,17 @@ PPPOEConnectDevice(void)
>      if (lcp_wantoptions[0].mru > ifr.ifr_mtu - TOTAL_OVERHEAD)
>  	lcp_wantoptions[0].mru =3D ifr.ifr_mtu - TOTAL_OVERHEAD;
> =20
> +    if (host_uniq) {
> +	if (!parseHostUniq(host_uniq, &conn->hostUniq))
> +	    fatal("Illegal value for host-uniq option");
> +    } else {
> +	/* if a custom host-uniq is not supplied, use our PID */
> +	pid_t pid =3D getpid();
> +	conn->hostUniq.type =3D htons(TAG_HOST_UNIQ);
> +	conn->hostUniq.length =3D htons(sizeof(pid));
> +	memcpy(conn->hostUniq.payload, &pid, sizeof(pid));
> +    }
> +
>      conn->acName =3D acName;
>      conn->serviceName =3D pppd_pppoe_service;
>      strlcpy(ppp_devnam, devnam, sizeof(ppp_devnam));
> diff --git a/pppd/plugins/rp-pppoe/pppoe-discovery.c b/pppd/plugins/rp-pp=
poe/pppoe-discovery.c
> index bce71fc..f71aec8 100644
> --- a/pppd/plugins/rp-pppoe/pppoe-discovery.c
> +++ b/pppd/plugins/rp-pppoe/pppoe-discovery.c
> @@ -356,7 +356,7 @@ packetIsForMe(PPPoEConnection *conn, PPPoEPacket *pac=
ket)
>      if (memcmp(packet->ethHdr.h_dest, conn->myEth, ETH_ALEN)) return 0;
> =20
>      /* If we're not using the Host-Unique tag, then accept the packet */
> -    if (!conn->useHostUniq) return 1;
> +    if (!conn->hostUniq.length) return 1;
> =20
>      parsePacket(packet, parseForHostUniq, &forMe);
>      return forMe;
> @@ -494,16 +494,12 @@ sendPADI(PPPoEConnection *conn)
>      cursor +=3D namelen + TAG_HDR_SIZE;
> =20
>      /* If we're using Host-Uniq, copy it over */
> -    if (conn->useHostUniq) {
> -	PPPoETag hostUniq;
> -	pid_t pid =3D getpid();
> -	hostUniq.type =3D htons(TAG_HOST_UNIQ);
> -	hostUniq.length =3D htons(sizeof(pid));
> -	memcpy(hostUniq.payload, &pid, sizeof(pid));
> -	CHECK_ROOM(cursor, packet.payload, sizeof(pid) + TAG_HDR_SIZE);
> -	memcpy(cursor, &hostUniq, sizeof(pid) + TAG_HDR_SIZE);
> -	cursor +=3D sizeof(pid) + TAG_HDR_SIZE;
> -	plen +=3D sizeof(pid) + TAG_HDR_SIZE;
> +    if (conn->hostUniq.length) {
> +	int len =3D ntohs(conn->hostUniq.length);
> +	CHECK_ROOM(cursor, packet.payload, len + TAG_HDR_SIZE);
> +	memcpy(cursor, &conn->hostUniq, len + TAG_HDR_SIZE);
> +	cursor +=3D len + TAG_HDR_SIZE;
> +	plen +=3D len + TAG_HDR_SIZE;
>      }
> =20
>      packet.length =3D htons(plen);
> @@ -669,7 +665,7 @@ int main(int argc, char *argv[])
>      conn->discoveryTimeout =3D PADI_TIMEOUT;
>      conn->discoveryAttempts =3D MAX_PADI_ATTEMPTS;
> =20
> -    while ((opt =3D getopt(argc, argv, "I:D:VUQS:C:t:a:h")) > 0) {
> +    while ((opt =3D getopt(argc, argv, "I:D:VUQS:C:W:t:a:h")) > 0) {
>  	switch(opt) {
>  	case 'S':
>  	    conn->serviceName =3D xstrdup(optarg);
> @@ -696,7 +692,25 @@ int main(int argc, char *argv[])
>  	    }
>  	    break;
>  	case 'U':
> -	    conn->useHostUniq =3D 1;
> +	    if(conn->hostUniq.length) {
> +		fprintf(stderr, "-U and -W are mutually exclusive\n");
> +		exit(EXIT_FAILURE);
> +	    } else {
> +		pid_t pid =3D getpid();
> +		conn->hostUniq.type =3D htons(TAG_HOST_UNIQ);
> +		conn->hostUniq.length =3D htons(sizeof(pid));
> +		memcpy(conn->hostUniq.payload, &pid, sizeof(pid));
> +	    }
> +	    break;
> +	case 'W':
> +	    if(conn->hostUniq.length) {
> +		fprintf(stderr, "-U and -W are mutually exclusive\n");
> +		exit(EXIT_FAILURE);
> +	    }
> +	    if (!parseHostUniq(optarg, &conn->hostUniq)) {
> +		fprintf(stderr, "Invalid host-uniq argument: %s\n", optarg);
> +		exit(EXIT_FAILURE);
> +            }
>  	    break;
>  	case 'D':
>  	    conn->debugFile =3D fopen(optarg, "w");
> @@ -777,6 +791,7 @@ void usage(void)
>  	    "   -S name        -- Set desired service name.\n"
>  	    "   -C name        -- Set desired access concentrator name.\n"
>  	    "   -U             -- Use Host-Unique to allow multiple PPPoE sessi=
ons.\n"
> +	    "   -W hexvalue    -- Set the Host-Unique to the supplied hex strin=
g.\n"
>  	    "   -h             -- Print usage information.\n");
>      fprintf(stderr, "\nVersion " RP_VERSION "\n");
>  }
> diff --git a/pppd/plugins/rp-pppoe/pppoe.h b/pppd/plugins/rp-pppoe/pppoe.h
> index 813dcf3..2ea153f 100644
> --- a/pppd/plugins/rp-pppoe/pppoe.h
> +++ b/pppd/plugins/rp-pppoe/pppoe.h
> @@ -21,6 +21,8 @@
> =20
>  #include <stdio.h>		/* For FILE */
>  #include <sys/types.h>		/* For pid_t */
> +#include <ctype.h>
> +#include <string.h>
> =20
>  /* How do we access raw Ethernet devices? */
>  #undef USE_LINUX_PACKET
> @@ -236,7 +238,7 @@ typedef struct PPPoEConnectionStruct {
>      char *serviceName;		/* Desired service name, if any */
>      char *acName;		/* Desired AC name, if any */
>      int synchronous;		/* Use synchronous PPP */
> -    int useHostUniq;		/* Use Host-Uniq tag */
> +    PPPoETag hostUniq;		/* Use Host-Uniq tag */
>      int printACNames;		/* Just print AC names */
>      FILE *debugFile;		/* Debug file for dumping packets */
>      int numPADOs;		/* Number of PADO packets received */
> @@ -293,6 +295,32 @@ void pppoe_printpkt(PPPoEPacket *packet,
>  		    void (*printer)(void *, char *, ...), void *arg);
>  void pppoe_log_packet(const char *prefix, PPPoEPacket *packet);
> =20
> +static inline int parseHostUniq(const char *uniq, PPPoETag *tag)
> +{
> +    unsigned i, len =3D strlen(uniq);
> +
> +#define hex(x) \
> +    (((x) <=3D '9') ? ((x) - '0') : \
> +        (((x) <=3D 'F') ? ((x) - 'A' + 10) : \
> +            ((x) - 'a' + 10)))
> +
> +    if (!len || len % 2 || len / 2 > sizeof(tag->payload))
> +        return 0;
> +
> +    for (i =3D 0; i < len; i +=3D 2) {
> +        if (!isxdigit(uniq[i]) || !isxdigit(uniq[i+1]))
> +            return 0;
> +
> +        tag->payload[i / 2] =3D (char)(hex(uniq[i]) << 4 | hex(uniq[i+1]=
));
> +    }
> +
> +#undef hex
> +
> +    tag->type =3D htons(TAG_HOST_UNIQ);
> +    tag->length =3D htons(len / 2);
> +    return 1;
> +}
> +
>  #define SET_STRING(var, val) do { if (var) free(var); var =3D strDup(val=
); } while(0);
> =20
>  #define CHECK_ROOM(cursor, start, len) \
> --=20
> 2.21.0
>=20

--=20
Tom Parkin
Katalix Systems Ltd
http://www.katalix.com
Catalysts for your Embedded Linux software development

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJc0UuKAAoJEJSMBmUKuovQR94IAIa9lbhcZ/+EbzQvvNv/VJXb
PZJPdv6M5Ou3xjI4yZBMDD2rvNZicPqfWa8l1IR/NzF73p+tti4dJ2hazuPnQ4lp
83/GeV4yDixIeqWs8vh9Nwqk9ZnCRX/b+S6y91Tjhofan3uEgClw8Sj3rVLtxgFG
9H7Frge2w9N+l/S8zwHiywf6NKfGUWXrvYp1SiRD8AbvrsZPwwAIHNxPfVeyg3vI
+2Yl/bAVNvYy3ZsTUxGDI359G2neb1zHP0NpS9qiky88oRlEkl9OUJ52lqDccAoM
K9qGuGhab8rTHO5mlqBGbEyJKNHSx/SbR6LmW/udHxHU0//OVIBGPJOCDT6V9w0=
=+lq1
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
