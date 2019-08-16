Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A48F290585
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 18:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbfHPQNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 12:13:04 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43999 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727357AbfHPQNE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 12:13:04 -0400
Received: by mail-pf1-f195.google.com with SMTP id v12so3341216pfn.10
        for <netdev@vger.kernel.org>; Fri, 16 Aug 2019 09:13:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WQixU0fZP8Z2akFwLIh0P4tmgyV6zz+KmxGRGUStWaQ=;
        b=xOAXPRWNhEyLpz5iV3fw1FUOQOW8dTEGcnwCP6caZ5GaOLsEchUFFmXhTe5qBoA/g9
         2oqzNTJ9ZBWRUZrCEY0WAzPvgiEl4i3zxsXTrq3j19eLGQvYdJnwr2KI9+6aVBY5OS87
         5p2OuhOdF1Do/PeNASm+OifXB0Yfcm4U5qoNejL4K2PZNEd303jSDIhn9J46fOSz+/f/
         4qZ0W7SFJ7Z42Tjc1tvyHsbkXSvg5n1njPXAZOZe0OjSc6tGryvg7u1z+Fm17BT1ktmL
         uSYejeqLUSR0HhYOi16fKFjsDCiiWVYmPXkruklOGb8il8rp/Oy9YpAhgH72mnbO/NX+
         d0FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WQixU0fZP8Z2akFwLIh0P4tmgyV6zz+KmxGRGUStWaQ=;
        b=ayg6t5S0RzKB7+7oDJEpNfLNADlrkOhqylESrxA8O/h8KEm/0apc5eyqERgr8CBjkU
         oP3vfDfp9RseEOVtbPHDX0ayJWc0MI5jiqHgYCvPajxV46ugvhbwonw3IxYTF7KyIuQe
         4CoYK1qv88HRLWxHBac8MPVj4VS9FswxaCOzssbX4HzCvBNsIR+Akbl0+0qhrGxo+cyj
         PPeLSLoCvTLAXB5OFB2SU4qeriU5slzgnjeUPudyCTVsotXgzzdAlaciGee4f6taDOqr
         vlda3/sxXhL3e039mv6Bmqqp/4LO02KoQ25eqigPMLp14X6r4pAIaf14vhELkZCrRf7H
         0lPA==
X-Gm-Message-State: APjAAAUSVX0ZExVI8LoVmlXHtid2DnEG9x+mnG4tzPnNlgZz39ryT/PW
        xLi5a9XT2bkbMjG4ZAj1zSDp0w==
X-Google-Smtp-Source: APXvYqyH1PmTjiubGIUx2pWC75jcQLxJflbOUj7GlvarB6iqgf4+i21Gxo3DKbYGLck6jU+tN6KoTg==
X-Received: by 2002:aa7:842f:: with SMTP id q15mr11503809pfn.250.1565971983984;
        Fri, 16 Aug 2019 09:13:03 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id z12sm1117798pfg.21.2019.08.16.09.13.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2019 09:13:03 -0700 (PDT)
Date:   Fri, 16 Aug 2019 09:13:02 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Petar Penkov <ppenkov.kernel@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, sdf@google.com,
        Petar Penkov <ppenkov@google.com>
Subject: Re: [bpf-next] selftests/bpf: fix race in test_tcp_rtt test
Message-ID: <20190816161302.GQ2820@mini-arch>
References: <20190816160339.249832-1-ppenkov.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190816160339.249832-1-ppenkov.kernel@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/16, Petar Penkov wrote:
> From: Petar Penkov <ppenkov@google.com>
> 
> There is a race in this test between receiving the ACK for the
> single-byte packet sent in the test, and reading the values from the
> map.
> 
> This patch fixes this by having the client wait until there are no more
> unacknowledged packets.
> 
> Before:
> for i in {1..1000}; do ../net/in_netns.sh ./test_tcp_rtt; \
> done | grep -c PASSED
> < trimmed error messages >
> 993
> 
> After:
> for i in {1..10000}; do ../net/in_netns.sh ./test_tcp_rtt; \
> done | grep -c PASSED
> 10000
> 
> Fixes: b55873984dab ("selftests/bpf: test BPF_SOCK_OPS_RTT_CB")
> Signed-off-by: Petar Penkov <ppenkov@google.com>
> ---
>  tools/testing/selftests/bpf/test_tcp_rtt.c | 31 ++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/tools/testing/selftests/bpf/test_tcp_rtt.c b/tools/testing/selftests/bpf/test_tcp_rtt.c
> index 90c3862f74a8..2b4754473956 100644
> --- a/tools/testing/selftests/bpf/test_tcp_rtt.c
> +++ b/tools/testing/selftests/bpf/test_tcp_rtt.c
> @@ -6,6 +6,7 @@
>  #include <sys/types.h>
>  #include <sys/socket.h>
>  #include <netinet/in.h>
> +#include <netinet/tcp.h>
>  #include <pthread.h>
>  
>  #include <linux/filter.h>
> @@ -34,6 +35,30 @@ static void send_byte(int fd)
>  		error(1, errno, "Failed to send single byte");
>  }
>  
> +static int wait_for_ack(int fd, int retries)
> +{
> +	struct tcp_info info;
> +	socklen_t optlen;
> +	int i, err;
> +
> +	for (i = 0; i < retries; i++) {
> +		optlen = sizeof(info);
> +		err = getsockopt(fd, SOL_TCP, TCP_INFO, &info, &optlen);
> +		if (err < 0) {
> +			log_err("Failed to lookup TCP stats");
> +			return err;
> +		}
> +
> +		if (info.tcpi_unacked == 0)
> +			return 0;
> +
> +		sleep(1);
Isn't it too big of a hammer? Maybe usleep(10) here and do x100 retries
instead?

> +	}
> +
> +	log_err("Did not receive ACK");
> +	return -1;
> +}
> +
>  static int verify_sk(int map_fd, int client_fd, const char *msg, __u32 invoked,
>  		     __u32 dsack_dups, __u32 delivered, __u32 delivered_ce,
>  		     __u32 icsk_retransmits)
> @@ -149,6 +174,11 @@ static int run_test(int cgroup_fd, int server_fd)
>  			 /*icsk_retransmits=*/0);
>  
>  	send_byte(client_fd);
> +	if (wait_for_ack(client_fd, 5) < 0) {
> +		err = -1;
> +		goto close_client_fd;
> +	}
> +
>  
>  	err += verify_sk(map_fd, client_fd, "first payload byte",
>  			 /*invoked=*/2,
> @@ -157,6 +187,7 @@ static int run_test(int cgroup_fd, int server_fd)
>  			 /*delivered_ce=*/0,
>  			 /*icsk_retransmits=*/0);
>  
> +close_client_fd:
>  	close(client_fd);
>  
>  close_bpf_object:
> -- 
> 2.23.0.rc1.153.gdeed80330f-goog
> 
