Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9091F23481E
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 17:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731418AbgGaPAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 11:00:18 -0400
Received: from www62.your-server.de ([213.133.104.62]:52184 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728713AbgGaPAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 11:00:17 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1WVy-0003JH-BO; Fri, 31 Jul 2020 17:00:06 +0200
Received: from [178.196.57.75] (helo=pc-9.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1k1WVy-000JZ6-47; Fri, 31 Jul 2020 17:00:06 +0200
Subject: Re: [PATCH bpf-next] bpf: fix compilation warning of selftests
To:     Jianlin Lv <Jianlin.Lv@arm.com>, bpf@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, ast@kernel.org, yhs@fb.com,
        Song.Zhu@arm.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20200731061600.18344-1-Jianlin.Lv@arm.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6f852dcb-abfc-78f8-69b8-3a5b83606793@iogearbox.net>
Date:   Fri, 31 Jul 2020 17:00:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200731061600.18344-1-Jianlin.Lv@arm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.3/25889/Thu Jul 30 17:03:53 2020)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/31/20 8:16 AM, Jianlin Lv wrote:
> Clang compiler version: 12.0.0
> The following warning appears during the selftests/bpf compilation:
> 
> prog_tests/send_signal.c:51:3: warning: ignoring return value of ‘write’,
> declared with attribute warn_unused_result [-Wunused-result]
>     51 |   write(pipe_c2p[1], buf, 1);
>        |   ^~~~~~~~~~~~~~~~~~~~~~~~~~
> prog_tests/send_signal.c:54:3: warning: ignoring return value of ‘read’,
> declared with attribute warn_unused_result [-Wunused-result]
>     54 |   read(pipe_p2c[0], buf, 1);
>        |   ^~~~~~~~~~~~~~~~~~~~~~~~~
> ......
> 
> prog_tests/stacktrace_build_id_nmi.c:13:2: warning: ignoring return value
> of ‘fscanf’,declared with attribute warn_unused_result [-Wunused-resul]
>     13 |  fscanf(f, "%llu", &sample_freq);
>        |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> test_tcpnotify_user.c:133:2: warning:ignoring return value of ‘system’,
> declared with attribute warn_unused_result [-Wunused-result]
>    133 |  system(test_script);
>        |  ^~~~~~~~~~~~~~~~~~~
> test_tcpnotify_user.c:138:2: warning:ignoring return value of ‘system’,
> declared with attribute warn_unused_result [-Wunused-result]
>    138 |  system(test_script);
>        |  ^~~~~~~~~~~~~~~~~~~
> test_tcpnotify_user.c:143:2: warning:ignoring return value of ‘system’,
> declared with attribute warn_unused_result [-Wunused-result]
>    143 |  system(test_script);
>        |  ^~~~~~~~~~~~~~~~~~~
> 
> Add code that fix compilation warning about ignoring return value and
> handles any errors; Check return value of library`s API make the code
> more secure.
> 
> Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>

Looks good overall, there is one small bug that slipped in, see below:

[...]
> diff --git a/tools/testing/selftests/bpf/test_tcpnotify_user.c b/tools/testing/selftests/bpf/test_tcpnotify_user.c
> index f9765ddf0761..869e28c92d73 100644
> --- a/tools/testing/selftests/bpf/test_tcpnotify_user.c
> +++ b/tools/testing/selftests/bpf/test_tcpnotify_user.c
> @@ -130,17 +130,26 @@ int main(int argc, char **argv)
>   	sprintf(test_script,
>   		"iptables -A INPUT -p tcp --dport %d -j DROP",
>   		TESTPORT);
> -	system(test_script);
> +	if (system(test_script)) {
> +		printf("FAILED: execute command: %s\n", test_script);
> +		goto err;
> +	}
>   
>   	sprintf(test_script,
>   		"nc 127.0.0.1 %d < /etc/passwd > /dev/null 2>&1 ",
>   		TESTPORT);
> -	system(test_script);
> +	if (system(test_script)) {
> +		printf("FAILED: execute command: %s\n", test_script);
> +		goto err;
> +	}

Did you try to run this test case? With the patch here it will fail:

   # ./test_tcpnotify_user
   FAILED: execute command: nc 127.0.0.1 12877 < /etc/passwd > /dev/null 2>&1

This is because nc returns 1 as exit code and for the test it is actually expected
to fail given the iptables rule we installed for TESTPORT right above and remove
again below.

Please adapt this and send a v2, thanks!

>   	sprintf(test_script,
>   		"iptables -D INPUT -p tcp --dport %d -j DROP",
>   		TESTPORT);
> -	system(test_script);
> +	if (system(test_script)) {
> +		printf("FAILED: execute command: %s\n", test_script);
> +		goto err;
> +	}
>   
>   	rv = bpf_map_lookup_elem(bpf_map__fd(global_map), &key, &g);
>   	if (rv != 0) {
> 

