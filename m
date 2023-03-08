Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF8A6AFBB1
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 02:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjCHBCt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 20:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229920AbjCHBCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 20:02:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA7D0A90A1;
        Tue,  7 Mar 2023 17:02:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A50E2B81B36;
        Wed,  8 Mar 2023 01:02:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B05C4339B;
        Wed,  8 Mar 2023 01:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678237340;
        bh=Lxae2JkB6XrMVsOr/4j17kRZOa6ZDLkrW786APkNZIY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W+RThuMkzeT6sn/qxtvA/Y9iq/SpR8sqv6dL9Q0OV18BA9STIjkrFzl1OqAs27RqG
         kQn8/xRh++twr2cFzCc8eecPCxE8CdHTrIwTnzI6SsDsvHTxeRukOsJOW4QIw2EBj1
         SqvokV/MOwfPCQWEbe2fjbFj5XXO7Zxst224d6hJSspN0Fvx/gywGBdkh9dc/1qM+2
         C1Ne9cwK/HwkU+MeaY8G6/LGSGgfWjcAm008Owoh2IDIvKnRHs/hQ5WhT2d7iHcHSe
         8tTjkHfZDoB8jlBlkDowlBrUzHXGOpSK2UmhC80yUzahkqSWRHbSnfSMcDbbw8BL0Q
         TrxCDHsAdEW4Q==
Date:   Tue, 7 Mar 2023 17:02:19 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, idosch@mellanox.com,
        danieller@mellanox.com, petrm@mellanox.com, shuah@kernel.org,
        pabeni@redhat.com, edumazet@google.com, davem@davemloft.net
Subject: Re: [PATCHv2] selftests: net: devlink_port_split.py: skip test if
 no suitable device available
Message-ID: <20230307170219.4699af9b@kernel.org>
In-Reply-To: <20230307150030.527726-1-po-hsu.lin@canonical.com>
References: <20230307150030.527726-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  7 Mar 2023 23:00:30 +0800 Po-Hsu Lin wrote:
> The `devlink -j port show` command output may not contain the "flavour"
> key, an example from s390x LPAR with Ubuntu 22.10 (5.19.0-37-generic),
> iproute2-5.15.0:
>   {"port":{"pci/0001:00:00.0/1":{"type":"eth","netdev":"ens301"},
>            "pci/0001:00:00.0/2":{"type":"eth","netdev":"ens301d1"},
>            "pci/0002:00:00.0/1":{"type":"eth","netdev":"ens317"},
>            "pci/0002:00:00.0/2":{"type":"eth","netdev":"ens317d1"}}}
> 
> This will cause a KeyError exception.

I looked closer and I don't understand why the key is not there.
Both 5.19 kernel should always put this argument out, and 5.15
iproute2 should always interpret it.

Am I looking wrong? Do you see how we can get a dump with no flavor?

I worry that this is some endianness problem, and we just misreport
stuff on big-endian.

> Create a validate_devlink_output() to check for this "flavour" from
> devlink command output to avoid this KeyError exception. Also let
> it handle the check for `devlink -j dev show` output in main().
> 
> Apart from this, if the test was not started because of any reason
> (e.g. "lanes" does not exist, max lanes is 0 or the flavour of the
> designated device is not "physical" and etc.) The script will still
> return 0 and thus causing a false-negative test result.
> 
> Use a test_ran flag to determine if these tests were skipped and
> return KSFT_SKIP to make it more clear.
> 
> V2: factor out the skip logic from main(), update commit message and
>     skip reasons accordingly.
> Link: https://bugs.launchpad.net/bugs/1937133
> Fixes: f3348a82e727 ("selftests: net: Add port split test")
> Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> ---
>  tools/testing/selftests/net/devlink_port_split.py | 36 +++++++++++++++++++----
>  1 file changed, 31 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/devlink_port_split.py b/tools/testing/selftests/net/devlink_port_split.py
> index 2b5d6ff..749606c 100755
> --- a/tools/testing/selftests/net/devlink_port_split.py
> +++ b/tools/testing/selftests/net/devlink_port_split.py
> @@ -59,6 +59,8 @@ class devlink_ports(object):
>          assert stderr == ""
>          ports = json.loads(stdout)['port']
>  
> +        validate_devlink_output(ports, 'flavour')

If it's just a matter of kernel/iproute2 version we shouldn't need to
check here again?

>          for port in ports:
>              if dev in port:
>                  if ports[port]['flavour'] == 'physical':
> @@ -220,6 +222,27 @@ def split_splittable_port(port, k, lanes, dev):
>      unsplit(port.bus_info)
>  
>  
> +def validate_devlink_output(devlink_data, target_property=None):
> +    """
> +    Determine if test should be skipped by checking:
> +      1. devlink_data contains values
> +      2. The target_property exist in devlink_data
> +    """
> +    skip_reason = None
> +    if any(devlink_data.values()):
> +        if target_property:
> +            skip_reason = "{} not found in devlink output, test skipped".format(target_property)
> +            for key in devlink_data:
> +                if target_property in devlink_data[key]:
> +                    skip_reason = None
> +    else:
> +        skip_reason = 'devlink output is empty, test skipped'
> +
> +    if skip_reason:
> +        print(skip_reason)
> +        sys.exit(KSFT_SKIP)

Looks good, so..

>  def make_parser():
>      parser = argparse.ArgumentParser(description='A test for port splitting.')
>      parser.add_argument('--dev',
> @@ -231,6 +254,7 @@ def make_parser():
>  
>  
>  def main(cmdline=None):
> +    test_ran = False

I don't think we need the test_ran tracking any more?

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
> +        sys.exit(KSFT_SKIP)
>  
>  
>  if __name__ == "__main__":

