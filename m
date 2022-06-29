Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C2B5606CC
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 18:57:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbiF2Q45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 12:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230426AbiF2Q4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 12:56:54 -0400
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099DA2250C
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 09:56:51 -0700 (PDT)
Received: from submission (posteo.de [185.67.36.169]) 
        by mout01.posteo.de (Postfix) with ESMTPS id DCBF524002B
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 18:56:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
        t=1656521809; bh=29ajJh0MHN97aVLux0uitCQId1MGwnNE5RwUBHtWjlA=;
        h=Date:From:To:Cc:Subject:From;
        b=j8kF+Gt8VJnnUBDpvkXUq5j49KysZiOclx1JetJLI1+eFqk6DWtLK2e9HK/OMsyat
         z9d1mATa1URH10UekCBNbuNqDfdhLAJZSdQ9f2bE/8Cm24W8+ERzryXpFqXufvHuea
         ypvYH/+307ymUgxelPz++jEnyqYZXCmUPam6xx7TjdWTosljqq5Sl7YWS5aEWKr4ss
         3hTLG/q622eE9KIgXYbXoIt5GCQJA7gYXqIk+6J2Y3VP/g8+VM7BU2uev8YdtK3TTF
         fDKQvtmFuDloTqh9MRjnsnK9NHzPsCqxUF9W9G1ADEs9rYllBf5/2RNqtseD9skxhR
         NHz8dD6czo36g==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4LY70Y334Gz6tmM;
        Wed, 29 Jun 2022 18:56:45 +0200 (CEST)
Date:   Wed, 29 Jun 2022 16:56:41 +0000
From:   Daniel =?utf-8?Q?M=C3=BCller?= <deso@posteo.net>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/2] bpftool: Use feature list in bash completion
Message-ID: <20220629165641.4nn7tf5imc7uklcn@muellerd-fedora-MJ0AC3F3>
References: <20220629144019.75181-1-quentin@isovalent.com>
 <20220629144019.75181-3-quentin@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220629144019.75181-3-quentin@isovalent.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 03:40:19PM +0100, Quentin Monnet wrote:
> Now that bpftool is able to produce a list of known program, map, attach
> types, let's use as much of this as we can in the bash completion file,
> so that we don't have to expand the list each time a new type is added
> to the kernel.
> 
> Also update the relevant test script to remove some checks that are no
> longer needed.
> 
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/bash-completion/bpftool     | 21 ++++---------------
>  .../selftests/bpf/test_bpftool_synctypes.py   | 20 +++---------------
>  2 files changed, 7 insertions(+), 34 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/bash-completion/bpftool b/tools/bpf/bpftool/bash-completion/bpftool
> index 9cef6516320b..ee177f83b179 100644
> --- a/tools/bpf/bpftool/bash-completion/bpftool
> +++ b/tools/bpf/bpftool/bash-completion/bpftool
> @@ -703,15 +703,8 @@ _bpftool()
>                              return 0
>                              ;;
>                          type)
> -                            local BPFTOOL_MAP_CREATE_TYPES='hash array \
> -                                prog_array perf_event_array percpu_hash \
> -                                percpu_array stack_trace cgroup_array lru_hash \
> -                                lru_percpu_hash lpm_trie array_of_maps \
> -                                hash_of_maps devmap devmap_hash sockmap cpumap \
> -                                xskmap sockhash cgroup_storage reuseport_sockarray \
> -                                percpu_cgroup_storage queue stack sk_storage \
> -                                struct_ops ringbuf inode_storage task_storage \
> -                                bloom_filter'
> +                            local BPFTOOL_MAP_CREATE_TYPES="$(bpftool feature list map_types | \
> +                                grep -v '^unspec$')"
>                              COMPREPLY=( $( compgen -W "$BPFTOOL_MAP_CREATE_TYPES" -- "$cur" ) )
>                              return 0
>                              ;;
> @@ -1039,14 +1032,8 @@ _bpftool()
>                      return 0
>                      ;;
>                  attach|detach)
> -                    local BPFTOOL_CGROUP_ATTACH_TYPES='cgroup_inet_ingress cgroup_inet_egress \
> -                        cgroup_inet_sock_create cgroup_sock_ops cgroup_device cgroup_inet4_bind \
> -                        cgroup_inet6_bind cgroup_inet4_post_bind cgroup_inet6_post_bind \
> -                        cgroup_inet4_connect cgroup_inet6_connect cgroup_inet4_getpeername \
> -                        cgroup_inet6_getpeername cgroup_inet4_getsockname cgroup_inet6_getsockname \
> -                        cgroup_udp4_sendmsg cgroup_udp6_sendmsg cgroup_udp4_recvmsg \
> -                        cgroup_udp6_recvmsg cgroup_sysctl cgroup_getsockopt cgroup_setsockopt \
> -                        cgroup_inet_sock_release'
> +                    local BPFTOOL_CGROUP_ATTACH_TYPES="$(bpftool feature list attach_types | \
> +                        grep '^cgroup_')"
>                      local ATTACH_FLAGS='multi override'
>                      local PROG_TYPE='id pinned tag name'
>                      # Check for $prev = $command first
> diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> index e443e6542cb9..a6410bebe603 100755
> --- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> +++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> @@ -471,12 +471,6 @@ class BashcompExtractor(FileExtractor):
>      def get_prog_attach_types(self):
>          return self.get_bashcomp_list('BPFTOOL_PROG_ATTACH_TYPES')
>  
> -    def get_map_types(self):
> -        return self.get_bashcomp_list('BPFTOOL_MAP_CREATE_TYPES')
> -
> -    def get_cgroup_attach_types(self):
> -        return self.get_bashcomp_list('BPFTOOL_CGROUP_ATTACH_TYPES')
> -
>  def verify(first_set, second_set, message):
>      """
>      Print all values that differ between two sets.
> @@ -516,17 +510,12 @@ def main():
>      man_map_types = man_map_info.get_map_types()
>      man_map_info.close()
>  
> -    bashcomp_info = BashcompExtractor()
> -    bashcomp_map_types = bashcomp_info.get_map_types()
> -
>      verify(source_map_types, help_map_types,
>              f'Comparing {BpfHeaderExtractor.filename} (bpf_map_type) and {MapFileExtractor.filename} (do_help() TYPE):')
>      verify(source_map_types, man_map_types,
>              f'Comparing {BpfHeaderExtractor.filename} (bpf_map_type) and {ManMapExtractor.filename} (TYPE):')
>      verify(help_map_options, man_map_options,
>              f'Comparing {MapFileExtractor.filename} (do_help() OPTIONS) and {ManMapExtractor.filename} (OPTIONS):')
> -    verify(source_map_types, bashcomp_map_types,
> -            f'Comparing {BpfHeaderExtractor.filename} (bpf_map_type) and {BashcompExtractor.filename} (BPFTOOL_MAP_CREATE_TYPES):')
>  
>      # Attach types (names)
>  
> @@ -542,8 +531,10 @@ def main():
>      man_prog_attach_types = man_prog_info.get_attach_types()
>      man_prog_info.close()
>  
> -    bashcomp_info.reset_read() # We stopped at map types, rewind
> +
> +    bashcomp_info = BashcompExtractor()
>      bashcomp_prog_attach_types = bashcomp_info.get_prog_attach_types()
> +    bashcomp_info.close()
>  
>      verify(source_prog_attach_types, help_prog_attach_types,
>              f'Comparing {ProgFileExtractor.filename} (bpf_attach_type) and {ProgFileExtractor.filename} (do_help() ATTACH_TYPE):')
> @@ -568,17 +559,12 @@ def main():
>      man_cgroup_attach_types = man_cgroup_info.get_attach_types()
>      man_cgroup_info.close()
>  
> -    bashcomp_cgroup_attach_types = bashcomp_info.get_cgroup_attach_types()
> -    bashcomp_info.close()
> -
>      verify(source_cgroup_attach_types, help_cgroup_attach_types,
>              f'Comparing {BpfHeaderExtractor.filename} (bpf_attach_type) and {CgroupFileExtractor.filename} (do_help() ATTACH_TYPE):')
>      verify(source_cgroup_attach_types, man_cgroup_attach_types,
>              f'Comparing {BpfHeaderExtractor.filename} (bpf_attach_type) and {ManCgroupExtractor.filename} (ATTACH_TYPE):')
>      verify(help_cgroup_options, man_cgroup_options,
>              f'Comparing {CgroupFileExtractor.filename} (do_help() OPTIONS) and {ManCgroupExtractor.filename} (OPTIONS):')
> -    verify(source_cgroup_attach_types, bashcomp_cgroup_attach_types,
> -            f'Comparing {BpfHeaderExtractor.filename} (bpf_attach_type) and {BashcompExtractor.filename} (BPFTOOL_CGROUP_ATTACH_TYPES):')
>  
>      # Options for remaining commands
>  

That is a nice simplification. Looks good to me.

Acked-by: Daniel Müller <deso@posteo.net>
