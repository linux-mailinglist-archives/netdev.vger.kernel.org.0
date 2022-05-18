Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CEB652BEBC
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 17:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239336AbiERPZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 11:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239271AbiERPZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 11:25:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF5938D9B;
        Wed, 18 May 2022 08:25:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4639660D57;
        Wed, 18 May 2022 15:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55967C385A9;
        Wed, 18 May 2022 15:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652887549;
        bh=EB+Iw7JCIoxncHMEJXgxtMfUlhqYaBpdxsilLCSagdg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Izh3lTYd8qhsqrmcFsk//dozeAm4Dqi2fVgWzfwjrUyZHgesdfk3VhzExCQavs2fG
         emVq4SD5P+NYoSDLoUJpLHC8msjvvUJ1RKvy1KLftYTarcDDzgFtFKltlyqLvmT1H1
         5HeWn670hCLEM1aoCbWgc+ZQ9KS0Y8vu8X1e3uB7G3pfSzvjDjXCcfsqkLrDaJ8Txa
         jh61wJD12hCoX0FcwkmSD2mF92lL9f+vVDtFOpdAdrur5lP0iEiitccd+qsARLJB3L
         Ls7XqYha4Ne/8nK+6ssUg+winav/JH9wHYoHInakTQYWjbkMp6O/SVmOXI/R8V8LPX
         DzuWPsbNYmGuA==
Date:   Wed, 18 May 2022 08:25:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net 0/2] selftests: net: add missing tests to Makefile
Message-ID: <20220518082548.24d63e25@kernel.org>
In-Reply-To: <YoSLx329qjT4Vrev@Laptop-X1>
References: <20220428044511.227416-1-liuhangbin@gmail.com>
        <20220429175604.249bb2fb@kernel.org>
        <YoM/Wr6FaTzgokx3@Laptop-X1>
        <20220517124517.363445f4@kernel.org>
        <YoSLx329qjT4Vrev@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 May 2022 14:01:43 +0800 Hangbin Liu wrote:
> > > +files=$(git show --name-status --oneline | grep -P '^A\ttools/testing/selftests/net/' | grep '\.sh$' | sed 's@A\ttools/testing/selftests/net/@@')

FWIW this will list just the names of bash scripts with no decoration:

  git show --pretty="" --name-only -- tools/testing/selftests/*.sh

And we can get the names of the files with basename:

  for f in $(git show --pretty="" --name-only); do basename $f; done

> > > +for file in $files; do
> > > +	if echo $file | grep forwarding; then
> > > +		file=$(echo $file | sed 's/forwarding\///')
> > > +		if ! grep -P "[\t| ]$file" tools/testing/selftests/net/forwarding/Makefile;then
> > > +			echo "new test $file not in selftests/net/forwarding/Makefile" >&$DESC_FD
> > > +			rc=1
> > > +		fi
> > > +	else
> > > +		if ! grep -P "[\t| ]$file" tools/testing/selftests/net/Makefile;then
> > > +			echo "new test $file not in selftests/net/Makefile" >&$DESC_FD
> > > +			rc=1
> > > +		fi  
> > 
> > Does it matter which exact selftest makefile the changes are?  
> 
> I only checked the tools/testing/selftests/net/Makefile and
> tools/testing/selftests/net/forwarding/Makefile at present.
> Maybe mptcp should also added?

Right, mptcp is one example, then we also have
tools/testing/selftests/drivers/net/

There may be new directories added, then we'd need to keep updating 
the test.

> > Maybe as a first stab we should just check if there are changes 
> > to anything in tools/testing/selftests/.*/Makefile?  
> 
> In my checking only shell scripts are checked, as most net net/forwarding tests
> using shell script for testing. But other sub-component may use c binary or
> python for testing. So I think there is no need to check all
> tools/testing/selftests/.*/Makefile. WDYT?

Not sure I understand, let me explain what I meant in more detail. 
I think we should make it generic. For example check the Makefile 
in the same location as the script:

  grep $(basename $f) $(dirname $f)/Makefile

And maybe just to be safe one directory level down?

  grep $(basename $f) $(dirname $(dirname $f))/Makefile

Instead of hardcoding the expected paths.
