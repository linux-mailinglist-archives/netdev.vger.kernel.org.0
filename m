Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D691200326
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 10:02:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730880AbgFSICo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 04:02:44 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:54594 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729548AbgFSICm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 04:02:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592553760;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ashA54ZHaKMG8ZvPjAufgf0QBFwQYuCanpRsuqqa5GQ=;
        b=WUb7iGMcy3uxkFwv6tquJuara2of2+8ikn+/DRPv/fgG9O6u2gvAK3/XF03993pg1nVmEd
        QWXq/Ch5cAl9M53dLZl/s4yIn59CUU6tVbHi+rYxyM5c4SQGW8SgenbnK0K6xfX2tCxBt4
        V6ImumoBszXFJf+w9Gwq71hNSos0aZs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-oVv_cv1qNd6Vo1h5By8T5g-1; Fri, 19 Jun 2020 04:02:36 -0400
X-MC-Unique: oVv_cv1qNd6Vo1h5By8T5g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 51C5A835B40;
        Fri, 19 Jun 2020 08:02:35 +0000 (UTC)
Received: from new-host-5 (unknown [10.40.192.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2022119C4F;
        Fri, 19 Jun 2020 08:02:31 +0000 (UTC)
Message-ID: <acfac92214ae5f77ce46a09242eabda7338cf6d6.camel@redhat.com>
Subject: Re: [PATCHv2 net] tc-testing: update geneve options match in
 tunnel_key unit tests
From:   Davide Caratti <dcaratti@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Lucas Bates <lucasb@mojatatu.com>,
        Simon Horman <simon.horman@netronome.com>,
        David Miller <davem@davemloft.net>
In-Reply-To: <20200619032445.664868-1-liuhangbin@gmail.com>
References: <20200618083705.449619-1-liuhangbin@gmail.com>
         <20200619032445.664868-1-liuhangbin@gmail.com>
Organization: red hat
Content-Type: text/plain; charset="UTF-8"
Date:   Fri, 19 Jun 2020 10:02:30 +0200
MIME-Version: 1.0
User-Agent: Evolution 3.36.1 (3.36.1-1.fc32) 
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

thanks for the patch,

On Fri, 2020-06-19 at 11:24 +0800, Hangbin Liu wrote:
> Since iproute2 commit f72c3ad00f3b ("tc: m_tunnel_key: add options
> support for vxlan"), the geneve opt output use key word "geneve_opts"
> instead of "geneve_opt". To make compatibility for both old and new
> iproute2, let's accept both "geneve_opt" and "geneve_opts".
> 
> Suggested-by: Davide Caratti <dcaratti@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  .../tc-testing/tc-tests/actions/tunnel_key.json    | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)

it has been successfully verified with the following command:

# for t in 4f20 e33d 0778 4ae8 4039 26a6 f44d ; do ./tdc.py -e $t ; done

using two tc binaries, one compiled from f72c3ad00f3b^ and the other one
from HEAD. I would have liked to see a list of OK with this command:

# ./tdc.cy -c tunnel_key

but (at least on my test setup) I see a failure here:

# ./tdc.py  -e 364d
Test 364d: Replace tunnel_key set action with all parameters and cookie

-----> prepare stage *** Could not execute: "$TC actions add action tunnel_key set src_ip 10.10.10.1 dst_ip 20.20.20.2 dst_port 3128 nocsum id 1 index 1 cooki
e aabbccddeeff112233445566778800a"

-----> prepare stage *** Error message: "Error: argument "aabbccddeeff112233445566778800a" is wrong: cookie must be a hex string

"                                      
returncode 255; expected [0]

-----> prepare stage *** Aborting test run.


<_io.BufferedReader name=3> *** stdout ***


<_io.BufferedReader name=5> *** stderr ***
"-----> prepare stage" did not complete successfully
Exception <class '__main__.PluginMgrTestFail'> ('setup', None, '"-----> prepare stage" did not complete successfully') (caught in test_runner, running test 2 
364d Replace tunnel_key set action with all parameters and cookie stage setup)
---------------                        
traceback                              
  File "./tdc.py", line 371, in test_runner
    res = run_one_test(pm, args, index, tidx)
  File "./tdc.py", line 272, in run_one_test
    prepare_env(args, pm, 'setup', "-----> prepare stage", tidx["setup"])
  File "./tdc.py", line 245, in prepare_env
    raise PluginMgrTestFail(
---------------                        
---------------                        

All test results:                      

1..1                                   
ok 1 364d - Replace tunnel_key set action with all parameters and cookie # skipped - "-----> prepare stage" did not complete successfully

I checked twice, and the problem only happens with the new iproute2 binary.
So, there seems to be an additional tdc breakage in the latest iproute2.
But the problem looks unrelated to your patch, and I follow-up in the next hours.

Tested-by: Davide Caratti <dcaratti@redhat.com>


