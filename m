Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDC25BB3A6
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 22:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230322AbiIPUrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 16:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiIPUrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 16:47:24 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2597B9F99;
        Fri, 16 Sep 2022 13:47:22 -0700 (PDT)
Received: from sslproxy03.your-server.de ([88.198.220.132])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1oZIF0-000Bpl-6v; Fri, 16 Sep 2022 22:47:14 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1oZIEz-0000BB-UG; Fri, 16 Sep 2022 22:47:13 +0200
Subject: Re: [PATCH bpf-next v2 0/3] A couple of small refactorings of BPF
 program call sites
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20220905193359.969347-1-toke@redhat.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <5e97c1e8-e7e4-27c4-aee7-ffa5958c6144@iogearbox.net>
Date:   Fri, 16 Sep 2022 22:47:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220905193359.969347-1-toke@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.6/26660/Fri Sep 16 09:57:04 2022)
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/5/22 9:33 PM, Toke Høiland-Jørgensen wrote:
> Stanislav suggested[0] that these small refactorings could be split out from the
> XDP queueing RFC series and merged separately. The first change is a small
> repacking of struct softnet_data, the others change the BPF call sites to
> support full 64-bit values as arguments to bpf_redirect_map() and as the return
> value of a BPF program, relying on the fact that BPF registers are always 64-bit
> wide to maintain backwards compatibility.

Looks like might still be issues on s390 [0] around retval checking, e.g.:

   [...]
   #122     pe_preserve_elems:FAIL
   test_raw_tp_test_run:PASS:parse_cpu_mask_file 0 nsec
   test_raw_tp_test_run:PASS:skel_open 0 nsec
   test_raw_tp_test_run:PASS:skel_attach 0 nsec
   test_raw_tp_test_run:PASS:open /proc/self/comm 0 nsec
   test_raw_tp_test_run:PASS:task rename 0 nsec
   test_raw_tp_test_run:PASS:check_count 0 nsec
   test_raw_tp_test_run:PASS:check_on_cpu 0 nsec
   test_raw_tp_test_run:PASS:test_run should fail for too small ctx 0 nsec
   test_raw_tp_test_run:PASS:test_run 0 nsec
   test_raw_tp_test_run:FAIL:check_retval unexpected check_retval: actual 0 != expected 26796
   test_raw_tp_test_run:PASS:test_run_opts 0 nsec
   test_raw_tp_test_run:PASS:check_on_cpu 0 nsec
   test_raw_tp_test_run:FAIL:check_retval unexpected check_retval: actual 0 != expected 26796
   test_raw_tp_test_run:PASS:test_run_opts 0 nsec
   test_raw_tp_test_run:PASS:check_on_cpu 0 nsec
   test_raw_tp_test_run:FAIL:check_retval unexpected check_retval: actual 0 != expected 26796
   test_raw_tp_test_run:PASS:test_run_opts should fail with ENXIO 0 nsec
   test_raw_tp_test_run:PASS:test_run_opts_fail 0 nsec
   test_raw_tp_test_run:PASS:test_run_opts should fail with EINVAL 0 nsec
   test_raw_tp_test_run:PASS:test_run_opts_fail 0 nsec
   [...]

Thanks,
Daniel

   [0] https://github.com/kernel-patches/bpf/actions/runs/3059535631/jobs/4939404438
