Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDD3ACF48B
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 10:06:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730515AbfJHIGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 04:06:02 -0400
Received: from mga07.intel.com ([134.134.136.100]:26151 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730414AbfJHIGC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 04:06:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 01:06:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,270,1566889200"; 
   d="scan'208";a="199747158"
Received: from iannetti-mobl1.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.252.56.81])
  by FMSMGA003.fm.intel.com with ESMTP; 08 Oct 2019 01:05:58 -0700
Subject: Re: [PATCH bpf-next 4/4] xdpsock: add an option to create AF_XDP
 sockets in XDP_DIRECT mode
To:     Sridhar Samudrala <sridhar.samudrala@intel.com>,
        magnus.karlsson@intel.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        maciej.fijalkowski@intel.com, tom.herbert@intel.com
References: <1570515415-45593-1-git-send-email-sridhar.samudrala@intel.com>
 <1570515415-45593-5-git-send-email-sridhar.samudrala@intel.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <645534a7-9606-88e0-a4f9-05ad04c7fb4e@intel.com>
Date:   Tue, 8 Oct 2019 10:05:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1570515415-45593-5-git-send-email-sridhar.samudrala@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-08 08:16, Sridhar Samudrala wrote:
> This option enables an AF_XDP socket to bind with a XDP_DIRECT flag
> that allows packets received on the associated queue to be received
> directly when an XDP program is not attached.
> 
> Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>

Acked-by: Björn Töpel <bjorn.topel@intel.com>

> ---
>   samples/bpf/xdpsock_user.c | 17 +++++++++++++----
>   1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
> index 405c4e091f8b..6f4633769968 100644
> --- a/samples/bpf/xdpsock_user.c
> +++ b/samples/bpf/xdpsock_user.c
> @@ -129,6 +129,9 @@ static void print_benchmark(bool running)
>   	if (opt_poll)
>   		printf("poll() ");
>   
> +	if (opt_xdp_bind_flags & XDP_DIRECT)
> +		printf("direct-xsk ");
> +
>   	if (running) {
>   		printf("running...");
>   		fflush(stdout);
> @@ -202,7 +205,8 @@ static void int_exit(int sig)
>   	dump_stats();
>   	xsk_socket__delete(xsks[0]->xsk);
>   	(void)xsk_umem__delete(umem);
> -	remove_xdp_program();
> +	if (!(opt_xdp_bind_flags & XDP_DIRECT))
> +		remove_xdp_program();
>   
>   	exit(EXIT_SUCCESS);
>   }
> @@ -213,7 +217,8 @@ static void __exit_with_error(int error, const char *file, const char *func,
>   	fprintf(stderr, "%s:%s:%i: errno: %d/\"%s\"\n", file, func,
>   		line, error, strerror(error));
>   	dump_stats();
> -	remove_xdp_program();
> +	if (!(opt_xdp_bind_flags & XDP_DIRECT))
> +		remove_xdp_program();
>   	exit(EXIT_FAILURE);
>   }
>   
> @@ -363,6 +368,7 @@ static struct option long_options[] = {
>   	{"frame-size", required_argument, 0, 'f'},
>   	{"no-need-wakeup", no_argument, 0, 'm'},
>   	{"unaligned", no_argument, 0, 'u'},
> +	{"direct-xsk", no_argument, 0, 'd'},
>   	{0, 0, 0, 0}
>   };
>   
> @@ -386,6 +392,7 @@ static void usage(const char *prog)
>   		"  -m, --no-need-wakeup Turn off use of driver need wakeup flag.\n"
>   		"  -f, --frame-size=n   Set the frame size (must be a power of two in aligned mode, default is %d).\n"
>   		"  -u, --unaligned	Enable unaligned chunk placement\n"
> +		"  -d, --direct-xsk	Direct packets to XDP socket.\n"
>   		"\n";
>   	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE);
>   	exit(EXIT_FAILURE);
> @@ -398,7 +405,7 @@ static void parse_command_line(int argc, char **argv)
>   	opterr = 0;
>   
>   	for (;;) {
> -		c = getopt_long(argc, argv, "Frtli:q:psSNn:czf:mu",
> +		c = getopt_long(argc, argv, "Frtli:q:psSNn:czf:mud",
>   				long_options, &option_index);
>   		if (c == -1)
>   			break;
> @@ -452,7 +459,9 @@ static void parse_command_line(int argc, char **argv)
>   			opt_need_wakeup = false;
>   			opt_xdp_bind_flags &= ~XDP_USE_NEED_WAKEUP;
>   			break;
> -
> +		case 'd':
> +			opt_xdp_bind_flags |= XDP_DIRECT;
> +			break;
>   		default:
>   			usage(basename(argv[0]));
>   		}
> 
