Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44C1EA6A30
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 15:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729353AbfICNlG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 09:41:06 -0400
Received: from www62.your-server.de ([213.133.104.62]:46650 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727107AbfICNlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 09:41:06 -0400
Received: from sslproxy01.your-server.de ([88.198.220.130])
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1i593N-0002SU-3x; Tue, 03 Sep 2019 15:41:01 +0200
Received: from [178.197.249.19] (helo=pc-63.home)
        by sslproxy01.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1i593M-000785-MS; Tue, 03 Sep 2019 15:41:00 +0200
Subject: Re: [PATCH bpf-next 1/2] selftests/bpf: test_progs: fix verbose mode
 garbage
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org
References: <20190831023427.239820-1-sdf@google.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <549829f5-6c93-6417-0582-ed10c7269c1f@iogearbox.net>
Date:   Tue, 3 Sep 2019 15:40:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190831023427.239820-1-sdf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25561/Tue Sep  3 10:24:26 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/19 4:34 AM, Stanislav Fomichev wrote:
> fseeko(.., 0, SEEK_SET) on a memstream just puts the buffer pointer
> to the beginning so when we call fflush on it we get some garbage
> log data from the previous test. Let's manually set terminating
> byte to zero at the reported buffer size.
> 
> To show the issue consider the following snippet:
> 
> 	stream = open_memstream (&buf, &len);
> 
> 	fprintf(stream, "aaa");
> 	fflush(stream);
> 	printf("buf=%s, len=%zu\n", buf, len);
> 	fseeko(stream, 0, SEEK_SET);
> 
> 	fprintf(stream, "b");
> 	fflush(stream);
> 	printf("buf=%s, len=%zu\n", buf, len);
> 
> Output:
> 
> 	buf=aaa, len=3
> 	buf=baa, len=1
> 
> Fixes: 946152b3c5d6 ("selftests/bpf: test_progs: switch to open_memstream")
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Both applied, thanks!
