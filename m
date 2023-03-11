Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81D46B5626
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 01:05:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjCKAFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 19:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229817AbjCKAFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 19:05:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16EA12EE44;
        Fri, 10 Mar 2023 16:05:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 922C6B8244B;
        Sat, 11 Mar 2023 00:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B535EC433EF;
        Sat, 11 Mar 2023 00:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678493143;
        bh=S9pojLzfmvbV7j7EBiSJw4lyKDgK9ycqKJazjt3AdXk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QvFm90hrD1s08qU1LCCnAKl767XB/pmtaY+gkJ/7bCieiwKXq5giAJSkQsZpaHdxa
         2az4FeJXANBYOKV7GByyIRKhSwo5NlThi+8DV1XJXjEtewqbT1sEf5l7rTxPGezxTN
         wMP1cg748Gpz9ki3xx1sB0hNYbAT/ACoRpKZkl+RRiNTr4Y0WX7kyB6eUPRwXFQaRI
         G5h+WPJ/gAkEqKWADHlzUcrPQOQAuQK/HC4anfCZ9+X5CPF8Wy7mLxpIBwi759s28X
         mpOjW/Hkl45Z0G+EVqrZfYiPmLaGZ8pxeSaXasBkW92XBWoWnQWNlaBNrwdGfOBxf6
         /WstJeOZOJZtg==
Date:   Fri, 10 Mar 2023 16:05:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, idosch@mellanox.com,
        danieller@mellanox.com, petrm@mellanox.com, shuah@kernel.org,
        pabeni@redhat.com, edumazet@google.com, davem@davemloft.net
Subject: Re: [PATCHv2] selftests: net: devlink_port_split.py: skip test if
 no suitable device available
Message-ID: <20230310160541.5ec7722a@kernel.org>
In-Reply-To: <20230307150030.527726-1-po-hsu.lin@canonical.com>
References: <20230307150030.527726-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Mar 2023 23:00:30 +0800 Po-Hsu Lin wrote:
>  def main(cmdline=None):
> +    test_ran = False

Could you move this variable init right before the 

	for port in ports.if_names:

line, and call it something like found_max_lanes ?

>      parser = make_parser()
>      args = parser.parse_args(cmdline)
>  
> @@ -240,12 +264,9 @@ def main(cmdline=None):
>          stdout, stderr = run_command(cmd)
>          assert stderr == ""
>  
> +        validate_devlink_output(json.loads(stdout))
>          devs = json.loads(stdout)['dev']
> -        if devs:
> -            dev = list(devs.keys())[0]
> -        else:
> -            print("no devlink device was found, test skipped")
> -            sys.exit(KSFT_SKIP)
> +        dev = list(devs.keys())[0]
>  
>      cmd = "devlink dev show %s" % dev
>      stdout, stderr = run_command(cmd)
> @@ -277,6 +298,11 @@ def main(cmdline=None):
>                  split_splittable_port(port, lane, max_lanes, dev)
>  
>                  lane //= 2
> +        test_ran = True
> +
> +    if not test_ran:
> +        print("Test not started, no suitable device for the test")

Then change the message to 

	f"Test not started, no port of device {dev} reports max_lanes"

> +        sys.exit(KSFT_SKIP)
>  
