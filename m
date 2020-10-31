Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CF02A19B0
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgJaSkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:40:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:58100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727967AbgJaSkl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 14:40:41 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E28BC206F9;
        Sat, 31 Oct 2020 18:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604169641;
        bh=AmHcrajXFTD5b2kQwoE6SZSnH0oCkrtF/rz8UCp0+G4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dfUgqPBrPA01vhYzCU2DeaQjozz7ees2NDmNV9KCPrl6+C3zWwJt68yhSRzH2m8TC
         HA9PlIJmxg091XVBhbygZ7aTcY480RBvlXB9MZrRAJwfbgeYMdjcnKO31/DZFkJpNa
         9M/31wupZpCmy1acJEGr2NG0Bd0SdhS8x3bpa1F4=
Date:   Sat, 31 Oct 2020 11:40:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH net-next] selftests/net: timestamping: add ptp v2
 support
Message-ID: <20201031114040.1facec0b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201029190931.30883-1-grygorii.strashko@ti.com>
References: <20201029190931.30883-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 21:09:31 +0200 Grygorii Strashko wrote:
> The timestamping tool is supporting now only PTPv1 (IEEE-1588 2002) while
> modern HW often supports also/only PTPv2.
> 
> Hence timestamping tool is still useful for sanity testing of PTP drivers
> HW timestamping capabilities it's reasonable to upstate it to support
> PTPv2. This patch adds corresponding support which can be enabled by using
> new parameter "PTPV2".
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

CC: Richard

> diff --git a/tools/testing/selftests/net/timestamping.c b/tools/testing/selftests/net/timestamping.c
> index f4bb4fef0f39..21091be70688 100644
> --- a/tools/testing/selftests/net/timestamping.c
> +++ b/tools/testing/selftests/net/timestamping.c
> @@ -59,7 +59,8 @@ static void usage(const char *error)
>  	       "  SOF_TIMESTAMPING_SOFTWARE - request reporting of software time stamps\n"
>  	       "  SOF_TIMESTAMPING_RAW_HARDWARE - request reporting of raw HW time stamps\n"
>  	       "  SIOCGSTAMP - check last socket time stamp\n"
> -	       "  SIOCGSTAMPNS - more accurate socket time stamp\n");
> +	       "  SIOCGSTAMPNS - more accurate socket time stamp\n"
> +	       "  PTPV2 - use PTPv2 messages\n");
>  	exit(1);
>  }
>  
> @@ -115,13 +116,28 @@ static const unsigned char sync[] = {
>  	0x00, 0x00, 0x00, 0x00
>  };
>  
> -static void sendpacket(int sock, struct sockaddr *addr, socklen_t addr_len)
> +static const unsigned char sync_v2[] = {
> +	0x00, 0x02, 0x00, 0x2C,
> +	0x00, 0x00, 0x02, 0x00,
> +	0x00, 0x00, 0x00, 0x00,
> +	0x00, 0x00, 0x00, 0x00,
> +	0x00, 0x00, 0x00, 0x00,
> +	0x00, 0x00, 0x00, 0xFF,
> +	0xFE, 0x00, 0x00, 0x00,
> +	0x00, 0x01, 0x00, 0x01,
> +	0x00, 0x00, 0x00, 0x00,
> +	0x00, 0x00, 0x00, 0x00,
> +	0x00, 0x00, 0x00, 0x00,
> +};
> +
> +static void sendpacket(int sock, struct sockaddr *addr, socklen_t addr_len, int ptpv2)
>  {
> +	size_t sync_len = ptpv2 ? sizeof(sync_v2) : sizeof(sync);
> +	const void *sync_p = ptpv2 ? sync_v2 : sync;
>  	struct timeval now;
>  	int res;
>  
> -	res = sendto(sock, sync, sizeof(sync), 0,
> -		addr, addr_len);
> +	res = sendto(sock, sync_p, sync_len, 0, addr, addr_len);
>  	gettimeofday(&now, 0);
>  	if (res < 0)
>  		printf("%s: %s\n", "send", strerror(errno));
> @@ -134,9 +150,11 @@ static void sendpacket(int sock, struct sockaddr *addr, socklen_t addr_len)
>  static void printpacket(struct msghdr *msg, int res,
>  			char *data,
>  			int sock, int recvmsg_flags,
> -			int siocgstamp, int siocgstampns)
> +			int siocgstamp, int siocgstampns, int ptpv2)
>  {
>  	struct sockaddr_in *from_addr = (struct sockaddr_in *)msg->msg_name;
> +	size_t sync_len = ptpv2 ? sizeof(sync_v2) : sizeof(sync);
> +	const void *sync_p = ptpv2 ? sync_v2 : sync;
>  	struct cmsghdr *cmsg;
>  	struct timeval tv;
>  	struct timespec ts;
> @@ -210,10 +228,9 @@ static void printpacket(struct msghdr *msg, int res,
>  					"probably SO_EE_ORIGIN_TIMESTAMPING"
>  #endif
>  					);
> -				if (res < sizeof(sync))
> +				if (res < sync_len)
>  					printf(" => truncated data?!");
> -				else if (!memcmp(sync, data + res - sizeof(sync),
> -							sizeof(sync)))
> +				else if (!memcmp(sync_p, data + res - sync_len, sync_len))
>  					printf(" => GOT OUR DATA BACK (HURRAY!)");
>  				break;
>  			}
> @@ -257,7 +274,7 @@ static void printpacket(struct msghdr *msg, int res,
>  }
>  
>  static void recvpacket(int sock, int recvmsg_flags,
> -		       int siocgstamp, int siocgstampns)
> +		       int siocgstamp, int siocgstampns, int ptpv2)
>  {
>  	char data[256];
>  	struct msghdr msg;
> @@ -288,7 +305,7 @@ static void recvpacket(int sock, int recvmsg_flags,
>  	} else {
>  		printpacket(&msg, res, data,
>  			    sock, recvmsg_flags,
> -			    siocgstamp, siocgstampns);
> +			    siocgstamp, siocgstampns, ptpv2);
>  	}
>  }
>  
> @@ -300,6 +317,7 @@ int main(int argc, char **argv)
>  	int siocgstamp = 0;
>  	int siocgstampns = 0;
>  	int ip_multicast_loop = 0;
> +	int ptpv2 = 0;
>  	char *interface;
>  	int i;
>  	int enabled = 1;
> @@ -335,6 +353,8 @@ int main(int argc, char **argv)
>  			siocgstampns = 1;
>  		else if (!strcasecmp(argv[i], "IP_MULTICAST_LOOP"))
>  			ip_multicast_loop = 1;
> +		else if (!strcasecmp(argv[i], "PTPV2"))
> +			ptpv2 = 1;
>  		else if (!strcasecmp(argv[i], "SOF_TIMESTAMPING_TX_HARDWARE"))
>  			so_timestamping_flags |= SOF_TIMESTAMPING_TX_HARDWARE;
>  		else if (!strcasecmp(argv[i], "SOF_TIMESTAMPING_TX_SOFTWARE"))
> @@ -369,6 +389,7 @@ int main(int argc, char **argv)
>  		HWTSTAMP_TX_ON : HWTSTAMP_TX_OFF;
>  	hwconfig.rx_filter =
>  		(so_timestamping_flags & SOF_TIMESTAMPING_RX_HARDWARE) ?
> +		ptpv2 ? HWTSTAMP_FILTER_PTP_V2_L4_SYNC :
>  		HWTSTAMP_FILTER_PTP_V1_L4_SYNC : HWTSTAMP_FILTER_NONE;
>  	hwconfig_requested = hwconfig;
>  	if (ioctl(sock, SIOCSHWTSTAMP, &hwtstamp) < 0) {
> @@ -496,16 +517,16 @@ int main(int argc, char **argv)
>  					printf("has error\n");
>  				recvpacket(sock, 0,
>  					   siocgstamp,
> -					   siocgstampns);
> +					   siocgstampns, ptpv2);
>  				recvpacket(sock, MSG_ERRQUEUE,
>  					   siocgstamp,
> -					   siocgstampns);
> +					   siocgstampns, ptpv2);
>  			}
>  		} else {
>  			/* write one packet */
>  			sendpacket(sock,
>  				   (struct sockaddr *)&addr,
> -				   sizeof(addr));
> +				   sizeof(addr), ptpv2);
>  			next.tv_sec += 5;
>  			continue;
>  		}

