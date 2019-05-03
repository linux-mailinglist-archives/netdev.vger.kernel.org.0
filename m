Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E33CF12689
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 05:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726401AbfECDni (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 23:43:38 -0400
Received: from mga12.intel.com ([192.55.52.136]:58696 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726229AbfECDni (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 23:43:38 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 20:43:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,424,1549958400"; 
   d="gz'50?scan'50,208,50";a="343019088"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 02 May 2019 20:43:32 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1hMP6i-000Afm-5e; Fri, 03 May 2019 11:43:32 +0800
Date:   Fri, 3 May 2019 11:42:47 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Jiong Wang <jiong.wang@netronome.com>
Cc:     kbuild-all@01.org, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net, bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com, Jiong Wang <jiong.wang@netronome.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v5 bpf-next 13/17] s390: bpf: eliminate zero extension
 code-gen
Message-ID: <201905031126.GbmiCqy9%lkp@intel.com>
References: <1556721842-29836-14-git-send-email-jiong.wang@netronome.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <1556721842-29836-14-git-send-email-jiong.wang@netronome.com>
X-Patchwork-Hint: ignore
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Jiong,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/0day-ci/linux/commits/Jiong-Wang/bpf-eliminate-zero-extensions-for-sub-register-writes/20190503-104459
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: s390-allyesconfig (attached as .config)
compiler: s390x-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=7.2.0 make.cross ARCH=s390 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

   arch/s390/net/bpf_jit_comp.c: In function 'bpf_jit_insn':
>> arch/s390/net/bpf_jit_comp.c:524:21: error: 'b1' undeclared (first use in this function)
      EMIT4(0xb9160000, b1, b1);
                        ^
   arch/s390/net/bpf_jit_comp.c:148:40: note: in definition of macro '_EMIT4'
      *(u32 *) (jit->prg_buf + jit->prg) = op; \
                                           ^~
>> arch/s390/net/bpf_jit_comp.c:524:3: note: in expansion of macro 'EMIT4'
      EMIT4(0xb9160000, b1, b1);
      ^~~~~
   arch/s390/net/bpf_jit_comp.c:524:21: note: each undeclared identifier is reported only once for each function it appears in
      EMIT4(0xb9160000, b1, b1);
                        ^
   arch/s390/net/bpf_jit_comp.c:148:40: note: in definition of macro '_EMIT4'
      *(u32 *) (jit->prg_buf + jit->prg) = op; \
                                           ^~
>> arch/s390/net/bpf_jit_comp.c:524:3: note: in expansion of macro 'EMIT4'
      EMIT4(0xb9160000, b1, b1);
      ^~~~~

vim +/b1 +524 arch/s390/net/bpf_jit_comp.c

   498	
   499	/*
   500	 * Compile one eBPF instruction into s390x code
   501	 *
   502	 * NOTE: Use noinline because for gcov (-fprofile-arcs) gcc allocates a lot of
   503	 * stack space for the large switch statement.
   504	 */
   505	static noinline int bpf_jit_insn(struct bpf_jit *jit, struct bpf_prog *fp, int i)
   506	{
   507		struct bpf_insn *insn = &fp->insnsi[i];
   508		int jmp_off, last, insn_count = 1;
   509		u32 dst_reg = insn->dst_reg;
   510		u32 src_reg = insn->src_reg;
   511		u32 *addrs = jit->addrs;
   512		s32 imm = insn->imm;
   513		s16 off = insn->off;
   514		unsigned int mask;
   515	
   516		if (dst_reg == BPF_REG_AX || src_reg == BPF_REG_AX)
   517			jit->seen |= SEEN_REG_AX;
   518		switch (insn->code) {
   519		/*
   520		 * BPF_ZEXT
   521		 */
   522		case BPF_ALU | BPF_ZEXT: /* dst = (u32) src + always does zext */
   523			/* llgfr %dst,%dst (zero extend to 64 bit) */
 > 524			EMIT4(0xb9160000, b1, b1);
   525			break;
   526		/*
   527		 * BPF_MOV
   528		 */
   529		case BPF_ALU | BPF_MOV | BPF_X: /* dst = (u32) src */
   530			/* llgfr %dst,%src */
   531			EMIT4(0xb9160000, dst_reg, src_reg);
   532			break;
   533		case BPF_ALU64 | BPF_MOV | BPF_X: /* dst = src */
   534			/* lgr %dst,%src */
   535			EMIT4(0xb9040000, dst_reg, src_reg);
   536			break;
   537		case BPF_ALU | BPF_MOV | BPF_K: /* dst = (u32) imm */
   538			/* llilf %dst,imm */
   539			EMIT6_IMM(0xc00f0000, dst_reg, imm);
   540			break;
   541		case BPF_ALU64 | BPF_MOV | BPF_K: /* dst = imm */
   542			/* lgfi %dst,imm */
   543			EMIT6_IMM(0xc0010000, dst_reg, imm);
   544			break;
   545		/*
   546		 * BPF_LD 64
   547		 */
   548		case BPF_LD | BPF_IMM | BPF_DW: /* dst = (u64) imm */
   549		{
   550			/* 16 byte instruction that uses two 'struct bpf_insn' */
   551			u64 imm64;
   552	
   553			imm64 = (u64)(u32) insn[0].imm | ((u64)(u32) insn[1].imm) << 32;
   554			/* lg %dst,<d(imm)>(%l) */
   555			EMIT6_DISP_LH(0xe3000000, 0x0004, dst_reg, REG_0, REG_L,
   556				      EMIT_CONST_U64(imm64));
   557			insn_count = 2;
   558			break;
   559		}
   560		/*
   561		 * BPF_ADD
   562		 */
   563		case BPF_ALU | BPF_ADD | BPF_X: /* dst = (u32) dst + (u32) src */
   564			/* ar %dst,%src */
   565			EMIT2(0x1a00, dst_reg, src_reg);
   566			EMIT_ZERO(dst_reg);
   567			break;
   568		case BPF_ALU64 | BPF_ADD | BPF_X: /* dst = dst + src */
   569			/* agr %dst,%src */
   570			EMIT4(0xb9080000, dst_reg, src_reg);
   571			break;
   572		case BPF_ALU | BPF_ADD | BPF_K: /* dst = (u32) dst + (u32) imm */
   573			if (!imm)
   574				break;
   575			/* alfi %dst,imm */
   576			EMIT6_IMM(0xc20b0000, dst_reg, imm);
   577			EMIT_ZERO(dst_reg);
   578			break;
   579		case BPF_ALU64 | BPF_ADD | BPF_K: /* dst = dst + imm */
   580			if (!imm)
   581				break;
   582			/* agfi %dst,imm */
   583			EMIT6_IMM(0xc2080000, dst_reg, imm);
   584			break;
   585		/*
   586		 * BPF_SUB
   587		 */
   588		case BPF_ALU | BPF_SUB | BPF_X: /* dst = (u32) dst - (u32) src */
   589			/* sr %dst,%src */
   590			EMIT2(0x1b00, dst_reg, src_reg);
   591			EMIT_ZERO(dst_reg);
   592			break;
   593		case BPF_ALU64 | BPF_SUB | BPF_X: /* dst = dst - src */
   594			/* sgr %dst,%src */
   595			EMIT4(0xb9090000, dst_reg, src_reg);
   596			break;
   597		case BPF_ALU | BPF_SUB | BPF_K: /* dst = (u32) dst - (u32) imm */
   598			if (!imm)
   599				break;
   600			/* alfi %dst,-imm */
   601			EMIT6_IMM(0xc20b0000, dst_reg, -imm);
   602			EMIT_ZERO(dst_reg);
   603			break;
   604		case BPF_ALU64 | BPF_SUB | BPF_K: /* dst = dst - imm */
   605			if (!imm)
   606				break;
   607			/* agfi %dst,-imm */
   608			EMIT6_IMM(0xc2080000, dst_reg, -imm);
   609			break;
   610		/*
   611		 * BPF_MUL
   612		 */
   613		case BPF_ALU | BPF_MUL | BPF_X: /* dst = (u32) dst * (u32) src */
   614			/* msr %dst,%src */
   615			EMIT4(0xb2520000, dst_reg, src_reg);
   616			EMIT_ZERO(dst_reg);
   617			break;
   618		case BPF_ALU64 | BPF_MUL | BPF_X: /* dst = dst * src */
   619			/* msgr %dst,%src */
   620			EMIT4(0xb90c0000, dst_reg, src_reg);
   621			break;
   622		case BPF_ALU | BPF_MUL | BPF_K: /* dst = (u32) dst * (u32) imm */
   623			if (imm == 1)
   624				break;
   625			/* msfi %r5,imm */
   626			EMIT6_IMM(0xc2010000, dst_reg, imm);
   627			EMIT_ZERO(dst_reg);
   628			break;
   629		case BPF_ALU64 | BPF_MUL | BPF_K: /* dst = dst * imm */
   630			if (imm == 1)
   631				break;
   632			/* msgfi %dst,imm */
   633			EMIT6_IMM(0xc2000000, dst_reg, imm);
   634			break;
   635		/*
   636		 * BPF_DIV / BPF_MOD
   637		 */
   638		case BPF_ALU | BPF_DIV | BPF_X: /* dst = (u32) dst / (u32) src */
   639		case BPF_ALU | BPF_MOD | BPF_X: /* dst = (u32) dst % (u32) src */
   640		{
   641			int rc_reg = BPF_OP(insn->code) == BPF_DIV ? REG_W1 : REG_W0;
   642	
   643			/* lhi %w0,0 */
   644			EMIT4_IMM(0xa7080000, REG_W0, 0);
   645			/* lr %w1,%dst */
   646			EMIT2(0x1800, REG_W1, dst_reg);
   647			/* dlr %w0,%src */
   648			EMIT4(0xb9970000, REG_W0, src_reg);
   649			/* llgfr %dst,%rc */
   650			EMIT4(0xb9160000, dst_reg, rc_reg);
   651			break;
   652		}
   653		case BPF_ALU64 | BPF_DIV | BPF_X: /* dst = dst / src */
   654		case BPF_ALU64 | BPF_MOD | BPF_X: /* dst = dst % src */
   655		{
   656			int rc_reg = BPF_OP(insn->code) == BPF_DIV ? REG_W1 : REG_W0;
   657	
   658			/* lghi %w0,0 */
   659			EMIT4_IMM(0xa7090000, REG_W0, 0);
   660			/* lgr %w1,%dst */
   661			EMIT4(0xb9040000, REG_W1, dst_reg);
   662			/* dlgr %w0,%dst */
   663			EMIT4(0xb9870000, REG_W0, src_reg);
   664			/* lgr %dst,%rc */
   665			EMIT4(0xb9040000, dst_reg, rc_reg);
   666			break;
   667		}
   668		case BPF_ALU | BPF_DIV | BPF_K: /* dst = (u32) dst / (u32) imm */
   669		case BPF_ALU | BPF_MOD | BPF_K: /* dst = (u32) dst % (u32) imm */
   670		{
   671			int rc_reg = BPF_OP(insn->code) == BPF_DIV ? REG_W1 : REG_W0;
   672	
   673			if (imm == 1) {
   674				if (BPF_OP(insn->code) == BPF_MOD)
   675					/* lhgi %dst,0 */
   676					EMIT4_IMM(0xa7090000, dst_reg, 0);
   677				break;
   678			}
   679			/* lhi %w0,0 */
   680			EMIT4_IMM(0xa7080000, REG_W0, 0);
   681			/* lr %w1,%dst */
   682			EMIT2(0x1800, REG_W1, dst_reg);
   683			/* dl %w0,<d(imm)>(%l) */
   684			EMIT6_DISP_LH(0xe3000000, 0x0097, REG_W0, REG_0, REG_L,
   685				      EMIT_CONST_U32(imm));
   686			/* llgfr %dst,%rc */
   687			EMIT4(0xb9160000, dst_reg, rc_reg);
   688			break;
   689		}
   690		case BPF_ALU64 | BPF_DIV | BPF_K: /* dst = dst / imm */
   691		case BPF_ALU64 | BPF_MOD | BPF_K: /* dst = dst % imm */
   692		{
   693			int rc_reg = BPF_OP(insn->code) == BPF_DIV ? REG_W1 : REG_W0;
   694	
   695			if (imm == 1) {
   696				if (BPF_OP(insn->code) == BPF_MOD)
   697					/* lhgi %dst,0 */
   698					EMIT4_IMM(0xa7090000, dst_reg, 0);
   699				break;
   700			}
   701			/* lghi %w0,0 */
   702			EMIT4_IMM(0xa7090000, REG_W0, 0);
   703			/* lgr %w1,%dst */
   704			EMIT4(0xb9040000, REG_W1, dst_reg);
   705			/* dlg %w0,<d(imm)>(%l) */
   706			EMIT6_DISP_LH(0xe3000000, 0x0087, REG_W0, REG_0, REG_L,
   707				      EMIT_CONST_U64(imm));
   708			/* lgr %dst,%rc */
   709			EMIT4(0xb9040000, dst_reg, rc_reg);
   710			break;
   711		}
   712		/*
   713		 * BPF_AND
   714		 */
   715		case BPF_ALU | BPF_AND | BPF_X: /* dst = (u32) dst & (u32) src */
   716			/* nr %dst,%src */
   717			EMIT2(0x1400, dst_reg, src_reg);
   718			EMIT_ZERO(dst_reg);
   719			break;
   720		case BPF_ALU64 | BPF_AND | BPF_X: /* dst = dst & src */
   721			/* ngr %dst,%src */
   722			EMIT4(0xb9800000, dst_reg, src_reg);
   723			break;
   724		case BPF_ALU | BPF_AND | BPF_K: /* dst = (u32) dst & (u32) imm */
   725			/* nilf %dst,imm */
   726			EMIT6_IMM(0xc00b0000, dst_reg, imm);
   727			EMIT_ZERO(dst_reg);
   728			break;
   729		case BPF_ALU64 | BPF_AND | BPF_K: /* dst = dst & imm */
   730			/* ng %dst,<d(imm)>(%l) */
   731			EMIT6_DISP_LH(0xe3000000, 0x0080, dst_reg, REG_0, REG_L,
   732				      EMIT_CONST_U64(imm));
   733			break;
   734		/*
   735		 * BPF_OR
   736		 */
   737		case BPF_ALU | BPF_OR | BPF_X: /* dst = (u32) dst | (u32) src */
   738			/* or %dst,%src */
   739			EMIT2(0x1600, dst_reg, src_reg);
   740			EMIT_ZERO(dst_reg);
   741			break;
   742		case BPF_ALU64 | BPF_OR | BPF_X: /* dst = dst | src */
   743			/* ogr %dst,%src */
   744			EMIT4(0xb9810000, dst_reg, src_reg);
   745			break;
   746		case BPF_ALU | BPF_OR | BPF_K: /* dst = (u32) dst | (u32) imm */
   747			/* oilf %dst,imm */
   748			EMIT6_IMM(0xc00d0000, dst_reg, imm);
   749			EMIT_ZERO(dst_reg);
   750			break;
   751		case BPF_ALU64 | BPF_OR | BPF_K: /* dst = dst | imm */
   752			/* og %dst,<d(imm)>(%l) */
   753			EMIT6_DISP_LH(0xe3000000, 0x0081, dst_reg, REG_0, REG_L,
   754				      EMIT_CONST_U64(imm));
   755			break;
   756		/*
   757		 * BPF_XOR
   758		 */
   759		case BPF_ALU | BPF_XOR | BPF_X: /* dst = (u32) dst ^ (u32) src */
   760			/* xr %dst,%src */
   761			EMIT2(0x1700, dst_reg, src_reg);
   762			EMIT_ZERO(dst_reg);
   763			break;
   764		case BPF_ALU64 | BPF_XOR | BPF_X: /* dst = dst ^ src */
   765			/* xgr %dst,%src */
   766			EMIT4(0xb9820000, dst_reg, src_reg);
   767			break;
   768		case BPF_ALU | BPF_XOR | BPF_K: /* dst = (u32) dst ^ (u32) imm */
   769			if (!imm)
   770				break;
   771			/* xilf %dst,imm */
   772			EMIT6_IMM(0xc0070000, dst_reg, imm);
   773			EMIT_ZERO(dst_reg);
   774			break;
   775		case BPF_ALU64 | BPF_XOR | BPF_K: /* dst = dst ^ imm */
   776			/* xg %dst,<d(imm)>(%l) */
   777			EMIT6_DISP_LH(0xe3000000, 0x0082, dst_reg, REG_0, REG_L,
   778				      EMIT_CONST_U64(imm));
   779			break;
   780		/*
   781		 * BPF_LSH
   782		 */
   783		case BPF_ALU | BPF_LSH | BPF_X: /* dst = (u32) dst << (u32) src */
   784			/* sll %dst,0(%src) */
   785			EMIT4_DISP(0x89000000, dst_reg, src_reg, 0);
   786			EMIT_ZERO(dst_reg);
   787			break;
   788		case BPF_ALU64 | BPF_LSH | BPF_X: /* dst = dst << src */
   789			/* sllg %dst,%dst,0(%src) */
   790			EMIT6_DISP_LH(0xeb000000, 0x000d, dst_reg, dst_reg, src_reg, 0);
   791			break;
   792		case BPF_ALU | BPF_LSH | BPF_K: /* dst = (u32) dst << (u32) imm */
   793			if (imm == 0)
   794				break;
   795			/* sll %dst,imm(%r0) */
   796			EMIT4_DISP(0x89000000, dst_reg, REG_0, imm);
   797			EMIT_ZERO(dst_reg);
   798			break;
   799		case BPF_ALU64 | BPF_LSH | BPF_K: /* dst = dst << imm */
   800			if (imm == 0)
   801				break;
   802			/* sllg %dst,%dst,imm(%r0) */
   803			EMIT6_DISP_LH(0xeb000000, 0x000d, dst_reg, dst_reg, REG_0, imm);
   804			break;
   805		/*
   806		 * BPF_RSH
   807		 */
   808		case BPF_ALU | BPF_RSH | BPF_X: /* dst = (u32) dst >> (u32) src */
   809			/* srl %dst,0(%src) */
   810			EMIT4_DISP(0x88000000, dst_reg, src_reg, 0);
   811			EMIT_ZERO(dst_reg);
   812			break;
   813		case BPF_ALU64 | BPF_RSH | BPF_X: /* dst = dst >> src */
   814			/* srlg %dst,%dst,0(%src) */
   815			EMIT6_DISP_LH(0xeb000000, 0x000c, dst_reg, dst_reg, src_reg, 0);
   816			break;
   817		case BPF_ALU | BPF_RSH | BPF_K: /* dst = (u32) dst >> (u32) imm */
   818			if (imm == 0)
   819				break;
   820			/* srl %dst,imm(%r0) */
   821			EMIT4_DISP(0x88000000, dst_reg, REG_0, imm);
   822			EMIT_ZERO(dst_reg);
   823			break;
   824		case BPF_ALU64 | BPF_RSH | BPF_K: /* dst = dst >> imm */
   825			if (imm == 0)
   826				break;
   827			/* srlg %dst,%dst,imm(%r0) */
   828			EMIT6_DISP_LH(0xeb000000, 0x000c, dst_reg, dst_reg, REG_0, imm);
   829			break;
   830		/*
   831		 * BPF_ARSH
   832		 */
   833		case BPF_ALU | BPF_ARSH | BPF_X: /* ((s32) dst) >>= src */
   834			/* sra %dst,%dst,0(%src) */
   835			EMIT4_DISP(0x8a000000, dst_reg, src_reg, 0);
   836			EMIT_ZERO(dst_reg);
   837			break;
   838		case BPF_ALU64 | BPF_ARSH | BPF_X: /* ((s64) dst) >>= src */
   839			/* srag %dst,%dst,0(%src) */
   840			EMIT6_DISP_LH(0xeb000000, 0x000a, dst_reg, dst_reg, src_reg, 0);
   841			break;
   842		case BPF_ALU | BPF_ARSH | BPF_K: /* ((s32) dst >> imm */
   843			if (imm == 0)
   844				break;
   845			/* sra %dst,imm(%r0) */
   846			EMIT4_DISP(0x8a000000, dst_reg, REG_0, imm);
   847			EMIT_ZERO(dst_reg);
   848			break;
   849		case BPF_ALU64 | BPF_ARSH | BPF_K: /* ((s64) dst) >>= imm */
   850			if (imm == 0)
   851				break;
   852			/* srag %dst,%dst,imm(%r0) */
   853			EMIT6_DISP_LH(0xeb000000, 0x000a, dst_reg, dst_reg, REG_0, imm);
   854			break;
   855		/*
   856		 * BPF_NEG
   857		 */
   858		case BPF_ALU | BPF_NEG: /* dst = (u32) -dst */
   859			/* lcr %dst,%dst */
   860			EMIT2(0x1300, dst_reg, dst_reg);
   861			EMIT_ZERO(dst_reg);
   862			break;
   863		case BPF_ALU64 | BPF_NEG: /* dst = -dst */
   864			/* lcgr %dst,%dst */
   865			EMIT4(0xb9130000, dst_reg, dst_reg);
   866			break;
   867		/*
   868		 * BPF_FROM_BE/LE
   869		 */
   870		case BPF_ALU | BPF_END | BPF_FROM_BE:
   871			/* s390 is big endian, therefore only clear high order bytes */
   872			switch (imm) {
   873			case 16: /* dst = (u16) cpu_to_be16(dst) */
   874				/* llghr %dst,%dst */
   875				EMIT4(0xb9850000, dst_reg, dst_reg);
   876				break;
   877			case 32: /* dst = (u32) cpu_to_be32(dst) */
   878				/* llgfr %dst,%dst */
   879				EMIT4(0xb9160000, dst_reg, dst_reg);
   880				break;
   881			case 64: /* dst = (u64) cpu_to_be64(dst) */
   882				break;
   883			}
   884			break;
   885		case BPF_ALU | BPF_END | BPF_FROM_LE:
   886			switch (imm) {
   887			case 16: /* dst = (u16) cpu_to_le16(dst) */
   888				/* lrvr %dst,%dst */
   889				EMIT4(0xb91f0000, dst_reg, dst_reg);
   890				/* srl %dst,16(%r0) */
   891				EMIT4_DISP(0x88000000, dst_reg, REG_0, 16);
   892				/* llghr %dst,%dst */
   893				EMIT4(0xb9850000, dst_reg, dst_reg);
   894				break;
   895			case 32: /* dst = (u32) cpu_to_le32(dst) */
   896				/* lrvr %dst,%dst */
   897				EMIT4(0xb91f0000, dst_reg, dst_reg);
   898				/* llgfr %dst,%dst */
   899				EMIT4(0xb9160000, dst_reg, dst_reg);
   900				break;
   901			case 64: /* dst = (u64) cpu_to_le64(dst) */
   902				/* lrvgr %dst,%dst */
   903				EMIT4(0xb90f0000, dst_reg, dst_reg);
   904				break;
   905			}
   906			break;
   907		/*
   908		 * BPF_ST(X)
   909		 */
   910		case BPF_STX | BPF_MEM | BPF_B: /* *(u8 *)(dst + off) = src_reg */
   911			/* stcy %src,off(%dst) */
   912			EMIT6_DISP_LH(0xe3000000, 0x0072, src_reg, dst_reg, REG_0, off);
   913			jit->seen |= SEEN_MEM;
   914			break;
   915		case BPF_STX | BPF_MEM | BPF_H: /* (u16 *)(dst + off) = src */
   916			/* sthy %src,off(%dst) */
   917			EMIT6_DISP_LH(0xe3000000, 0x0070, src_reg, dst_reg, REG_0, off);
   918			jit->seen |= SEEN_MEM;
   919			break;
   920		case BPF_STX | BPF_MEM | BPF_W: /* *(u32 *)(dst + off) = src */
   921			/* sty %src,off(%dst) */
   922			EMIT6_DISP_LH(0xe3000000, 0x0050, src_reg, dst_reg, REG_0, off);
   923			jit->seen |= SEEN_MEM;
   924			break;
   925		case BPF_STX | BPF_MEM | BPF_DW: /* (u64 *)(dst + off) = src */
   926			/* stg %src,off(%dst) */
   927			EMIT6_DISP_LH(0xe3000000, 0x0024, src_reg, dst_reg, REG_0, off);
   928			jit->seen |= SEEN_MEM;
   929			break;
   930		case BPF_ST | BPF_MEM | BPF_B: /* *(u8 *)(dst + off) = imm */
   931			/* lhi %w0,imm */
   932			EMIT4_IMM(0xa7080000, REG_W0, (u8) imm);
   933			/* stcy %w0,off(dst) */
   934			EMIT6_DISP_LH(0xe3000000, 0x0072, REG_W0, dst_reg, REG_0, off);
   935			jit->seen |= SEEN_MEM;
   936			break;
   937		case BPF_ST | BPF_MEM | BPF_H: /* (u16 *)(dst + off) = imm */
   938			/* lhi %w0,imm */
   939			EMIT4_IMM(0xa7080000, REG_W0, (u16) imm);
   940			/* sthy %w0,off(dst) */
   941			EMIT6_DISP_LH(0xe3000000, 0x0070, REG_W0, dst_reg, REG_0, off);
   942			jit->seen |= SEEN_MEM;
   943			break;
   944		case BPF_ST | BPF_MEM | BPF_W: /* *(u32 *)(dst + off) = imm */
   945			/* llilf %w0,imm  */
   946			EMIT6_IMM(0xc00f0000, REG_W0, (u32) imm);
   947			/* sty %w0,off(%dst) */
   948			EMIT6_DISP_LH(0xe3000000, 0x0050, REG_W0, dst_reg, REG_0, off);
   949			jit->seen |= SEEN_MEM;
   950			break;
   951		case BPF_ST | BPF_MEM | BPF_DW: /* *(u64 *)(dst + off) = imm */
   952			/* lgfi %w0,imm */
   953			EMIT6_IMM(0xc0010000, REG_W0, imm);
   954			/* stg %w0,off(%dst) */
   955			EMIT6_DISP_LH(0xe3000000, 0x0024, REG_W0, dst_reg, REG_0, off);
   956			jit->seen |= SEEN_MEM;
   957			break;
   958		/*
   959		 * BPF_STX XADD (atomic_add)
   960		 */
   961		case BPF_STX | BPF_XADD | BPF_W: /* *(u32 *)(dst + off) += src */
   962			/* laal %w0,%src,off(%dst) */
   963			EMIT6_DISP_LH(0xeb000000, 0x00fa, REG_W0, src_reg,
   964				      dst_reg, off);
   965			jit->seen |= SEEN_MEM;
   966			break;
   967		case BPF_STX | BPF_XADD | BPF_DW: /* *(u64 *)(dst + off) += src */
   968			/* laalg %w0,%src,off(%dst) */
   969			EMIT6_DISP_LH(0xeb000000, 0x00ea, REG_W0, src_reg,
   970				      dst_reg, off);
   971			jit->seen |= SEEN_MEM;
   972			break;
   973		/*
   974		 * BPF_LDX
   975		 */
   976		case BPF_LDX | BPF_MEM | BPF_B: /* dst = *(u8 *)(ul) (src + off) */
   977			/* llgc %dst,0(off,%src) */
   978			EMIT6_DISP_LH(0xe3000000, 0x0090, dst_reg, src_reg, REG_0, off);
   979			jit->seen |= SEEN_MEM;
   980			break;
   981		case BPF_LDX | BPF_MEM | BPF_H: /* dst = *(u16 *)(ul) (src + off) */
   982			/* llgh %dst,0(off,%src) */
   983			EMIT6_DISP_LH(0xe3000000, 0x0091, dst_reg, src_reg, REG_0, off);
   984			jit->seen |= SEEN_MEM;
   985			break;
   986		case BPF_LDX | BPF_MEM | BPF_W: /* dst = *(u32 *)(ul) (src + off) */
   987			/* llgf %dst,off(%src) */
   988			jit->seen |= SEEN_MEM;
   989			EMIT6_DISP_LH(0xe3000000, 0x0016, dst_reg, src_reg, REG_0, off);
   990			break;
   991		case BPF_LDX | BPF_MEM | BPF_DW: /* dst = *(u64 *)(ul) (src + off) */
   992			/* lg %dst,0(off,%src) */
   993			jit->seen |= SEEN_MEM;
   994			EMIT6_DISP_LH(0xe3000000, 0x0004, dst_reg, src_reg, REG_0, off);
   995			break;
   996		/*
   997		 * BPF_JMP / CALL
   998		 */
   999		case BPF_JMP | BPF_CALL:
  1000		{
  1001			/*
  1002			 * b0 = (__bpf_call_base + imm)(b1, b2, b3, b4, b5)
  1003			 */
  1004			const u64 func = (u64)__bpf_call_base + imm;
  1005	
  1006			REG_SET_SEEN(BPF_REG_5);
  1007			jit->seen |= SEEN_FUNC;
  1008			/* lg %w1,<d(imm)>(%l) */
  1009			EMIT6_DISP_LH(0xe3000000, 0x0004, REG_W1, REG_0, REG_L,
  1010				      EMIT_CONST_U64(func));
  1011			if (IS_ENABLED(CC_USING_EXPOLINE) && !nospec_disable) {
  1012				/* brasl %r14,__s390_indirect_jump_r1 */
  1013				EMIT6_PCREL_RILB(0xc0050000, REG_14, jit->r1_thunk_ip);
  1014			} else {
  1015				/* basr %r14,%w1 */
  1016				EMIT2(0x0d00, REG_14, REG_W1);
  1017			}
  1018			/* lgr %b0,%r2: load return value into %b0 */
  1019			EMIT4(0xb9040000, BPF_REG_0, REG_2);
  1020			break;
  1021		}
  1022		case BPF_JMP | BPF_TAIL_CALL:
  1023			/*
  1024			 * Implicit input:
  1025			 *  B1: pointer to ctx
  1026			 *  B2: pointer to bpf_array
  1027			 *  B3: index in bpf_array
  1028			 */
  1029			jit->seen |= SEEN_TAIL_CALL;
  1030	
  1031			/*
  1032			 * if (index >= array->map.max_entries)
  1033			 *         goto out;
  1034			 */
  1035	
  1036			/* llgf %w1,map.max_entries(%b2) */
  1037			EMIT6_DISP_LH(0xe3000000, 0x0016, REG_W1, REG_0, BPF_REG_2,
  1038				      offsetof(struct bpf_array, map.max_entries));
  1039			/* clgrj %b3,%w1,0xa,label0: if %b3 >= %w1 goto out */
  1040			EMIT6_PCREL_LABEL(0xec000000, 0x0065, BPF_REG_3,
  1041					  REG_W1, 0, 0xa);
  1042	
  1043			/*
  1044			 * if (tail_call_cnt++ > MAX_TAIL_CALL_CNT)
  1045			 *         goto out;
  1046			 */
  1047	
  1048			if (jit->seen & SEEN_STACK)
  1049				off = STK_OFF_TCCNT + STK_OFF + fp->aux->stack_depth;
  1050			else
  1051				off = STK_OFF_TCCNT;
  1052			/* lhi %w0,1 */
  1053			EMIT4_IMM(0xa7080000, REG_W0, 1);
  1054			/* laal %w1,%w0,off(%r15) */
  1055			EMIT6_DISP_LH(0xeb000000, 0x00fa, REG_W1, REG_W0, REG_15, off);
  1056			/* clij %w1,MAX_TAIL_CALL_CNT,0x2,label0 */
  1057			EMIT6_PCREL_IMM_LABEL(0xec000000, 0x007f, REG_W1,
  1058					      MAX_TAIL_CALL_CNT, 0, 0x2);
  1059	
  1060			/*
  1061			 * prog = array->ptrs[index];
  1062			 * if (prog == NULL)
  1063			 *         goto out;
  1064			 */
  1065	
  1066			/* sllg %r1,%b3,3: %r1 = index * 8 */
  1067			EMIT6_DISP_LH(0xeb000000, 0x000d, REG_1, BPF_REG_3, REG_0, 3);
  1068			/* lg %r1,prog(%b2,%r1) */
  1069			EMIT6_DISP_LH(0xe3000000, 0x0004, REG_1, BPF_REG_2,
  1070				      REG_1, offsetof(struct bpf_array, ptrs));
  1071			/* clgij %r1,0,0x8,label0 */
  1072			EMIT6_PCREL_IMM_LABEL(0xec000000, 0x007d, REG_1, 0, 0, 0x8);
  1073	
  1074			/*
  1075			 * Restore registers before calling function
  1076			 */
  1077			save_restore_regs(jit, REGS_RESTORE, fp->aux->stack_depth);
  1078	
  1079			/*
  1080			 * goto *(prog->bpf_func + tail_call_start);
  1081			 */
  1082	
  1083			/* lg %r1,bpf_func(%r1) */
  1084			EMIT6_DISP_LH(0xe3000000, 0x0004, REG_1, REG_1, REG_0,
  1085				      offsetof(struct bpf_prog, bpf_func));
  1086			/* bc 0xf,tail_call_start(%r1) */
  1087			_EMIT4(0x47f01000 + jit->tail_call_start);
  1088			/* out: */
  1089			jit->labels[0] = jit->prg;
  1090			break;
  1091		case BPF_JMP | BPF_EXIT: /* return b0 */
  1092			last = (i == fp->len - 1) ? 1 : 0;
  1093			if (last && !(jit->seen & SEEN_RET0))
  1094				break;
  1095			/* j <exit> */
  1096			EMIT4_PCREL(0xa7f40000, jit->exit_ip - jit->prg);
  1097			break;
  1098		/*
  1099		 * Branch relative (number of skipped instructions) to offset on
  1100		 * condition.
  1101		 *
  1102		 * Condition code to mask mapping:
  1103		 *
  1104		 * CC | Description	   | Mask
  1105		 * ------------------------------
  1106		 * 0  | Operands equal	   |	8
  1107		 * 1  | First operand low  |	4
  1108		 * 2  | First operand high |	2
  1109		 * 3  | Unused		   |	1
  1110		 *
  1111		 * For s390x relative branches: ip = ip + off_bytes
  1112		 * For BPF relative branches:	insn = insn + off_insns + 1
  1113		 *
  1114		 * For example for s390x with offset 0 we jump to the branch
  1115		 * instruction itself (loop) and for BPF with offset 0 we
  1116		 * branch to the instruction behind the branch.
  1117		 */
  1118		case BPF_JMP | BPF_JA: /* if (true) */
  1119			mask = 0xf000; /* j */
  1120			goto branch_oc;
  1121		case BPF_JMP | BPF_JSGT | BPF_K: /* ((s64) dst > (s64) imm) */
  1122		case BPF_JMP32 | BPF_JSGT | BPF_K: /* ((s32) dst > (s32) imm) */
  1123			mask = 0x2000; /* jh */
  1124			goto branch_ks;
  1125		case BPF_JMP | BPF_JSLT | BPF_K: /* ((s64) dst < (s64) imm) */
  1126		case BPF_JMP32 | BPF_JSLT | BPF_K: /* ((s32) dst < (s32) imm) */
  1127			mask = 0x4000; /* jl */
  1128			goto branch_ks;
  1129		case BPF_JMP | BPF_JSGE | BPF_K: /* ((s64) dst >= (s64) imm) */
  1130		case BPF_JMP32 | BPF_JSGE | BPF_K: /* ((s32) dst >= (s32) imm) */
  1131			mask = 0xa000; /* jhe */
  1132			goto branch_ks;
  1133		case BPF_JMP | BPF_JSLE | BPF_K: /* ((s64) dst <= (s64) imm) */
  1134		case BPF_JMP32 | BPF_JSLE | BPF_K: /* ((s32) dst <= (s32) imm) */
  1135			mask = 0xc000; /* jle */
  1136			goto branch_ks;
  1137		case BPF_JMP | BPF_JGT | BPF_K: /* (dst_reg > imm) */
  1138		case BPF_JMP32 | BPF_JGT | BPF_K: /* ((u32) dst_reg > (u32) imm) */
  1139			mask = 0x2000; /* jh */
  1140			goto branch_ku;
  1141		case BPF_JMP | BPF_JLT | BPF_K: /* (dst_reg < imm) */
  1142		case BPF_JMP32 | BPF_JLT | BPF_K: /* ((u32) dst_reg < (u32) imm) */
  1143			mask = 0x4000; /* jl */
  1144			goto branch_ku;
  1145		case BPF_JMP | BPF_JGE | BPF_K: /* (dst_reg >= imm) */
  1146		case BPF_JMP32 | BPF_JGE | BPF_K: /* ((u32) dst_reg >= (u32) imm) */
  1147			mask = 0xa000; /* jhe */
  1148			goto branch_ku;
  1149		case BPF_JMP | BPF_JLE | BPF_K: /* (dst_reg <= imm) */
  1150		case BPF_JMP32 | BPF_JLE | BPF_K: /* ((u32) dst_reg <= (u32) imm) */
  1151			mask = 0xc000; /* jle */
  1152			goto branch_ku;
  1153		case BPF_JMP | BPF_JNE | BPF_K: /* (dst_reg != imm) */
  1154		case BPF_JMP32 | BPF_JNE | BPF_K: /* ((u32) dst_reg != (u32) imm) */
  1155			mask = 0x7000; /* jne */
  1156			goto branch_ku;
  1157		case BPF_JMP | BPF_JEQ | BPF_K: /* (dst_reg == imm) */
  1158		case BPF_JMP32 | BPF_JEQ | BPF_K: /* ((u32) dst_reg == (u32) imm) */
  1159			mask = 0x8000; /* je */
  1160			goto branch_ku;
  1161		case BPF_JMP | BPF_JSET | BPF_K: /* (dst_reg & imm) */
  1162		case BPF_JMP32 | BPF_JSET | BPF_K: /* ((u32) dst_reg & (u32) imm) */
  1163			mask = 0x7000; /* jnz */
  1164			if (BPF_CLASS(insn->code) == BPF_JMP32) {
  1165				/* llilf %w1,imm (load zero extend imm) */
  1166				EMIT6_IMM(0xc00f0000, REG_W1, imm);
  1167				/* nr %w1,%dst */
  1168				EMIT2(0x1400, REG_W1, dst_reg);
  1169			} else {
  1170				/* lgfi %w1,imm (load sign extend imm) */
  1171				EMIT6_IMM(0xc0010000, REG_W1, imm);
  1172				/* ngr %w1,%dst */
  1173				EMIT4(0xb9800000, REG_W1, dst_reg);
  1174			}
  1175			goto branch_oc;
  1176	
  1177		case BPF_JMP | BPF_JSGT | BPF_X: /* ((s64) dst > (s64) src) */
  1178		case BPF_JMP32 | BPF_JSGT | BPF_X: /* ((s32) dst > (s32) src) */
  1179			mask = 0x2000; /* jh */
  1180			goto branch_xs;
  1181		case BPF_JMP | BPF_JSLT | BPF_X: /* ((s64) dst < (s64) src) */
  1182		case BPF_JMP32 | BPF_JSLT | BPF_X: /* ((s32) dst < (s32) src) */
  1183			mask = 0x4000; /* jl */
  1184			goto branch_xs;
  1185		case BPF_JMP | BPF_JSGE | BPF_X: /* ((s64) dst >= (s64) src) */
  1186		case BPF_JMP32 | BPF_JSGE | BPF_X: /* ((s32) dst >= (s32) src) */
  1187			mask = 0xa000; /* jhe */
  1188			goto branch_xs;
  1189		case BPF_JMP | BPF_JSLE | BPF_X: /* ((s64) dst <= (s64) src) */
  1190		case BPF_JMP32 | BPF_JSLE | BPF_X: /* ((s32) dst <= (s32) src) */
  1191			mask = 0xc000; /* jle */
  1192			goto branch_xs;
  1193		case BPF_JMP | BPF_JGT | BPF_X: /* (dst > src) */
  1194		case BPF_JMP32 | BPF_JGT | BPF_X: /* ((u32) dst > (u32) src) */
  1195			mask = 0x2000; /* jh */
  1196			goto branch_xu;
  1197		case BPF_JMP | BPF_JLT | BPF_X: /* (dst < src) */
  1198		case BPF_JMP32 | BPF_JLT | BPF_X: /* ((u32) dst < (u32) src) */
  1199			mask = 0x4000; /* jl */
  1200			goto branch_xu;
  1201		case BPF_JMP | BPF_JGE | BPF_X: /* (dst >= src) */
  1202		case BPF_JMP32 | BPF_JGE | BPF_X: /* ((u32) dst >= (u32) src) */
  1203			mask = 0xa000; /* jhe */
  1204			goto branch_xu;
  1205		case BPF_JMP | BPF_JLE | BPF_X: /* (dst <= src) */
  1206		case BPF_JMP32 | BPF_JLE | BPF_X: /* ((u32) dst <= (u32) src) */
  1207			mask = 0xc000; /* jle */
  1208			goto branch_xu;
  1209		case BPF_JMP | BPF_JNE | BPF_X: /* (dst != src) */
  1210		case BPF_JMP32 | BPF_JNE | BPF_X: /* ((u32) dst != (u32) src) */
  1211			mask = 0x7000; /* jne */
  1212			goto branch_xu;
  1213		case BPF_JMP | BPF_JEQ | BPF_X: /* (dst == src) */
  1214		case BPF_JMP32 | BPF_JEQ | BPF_X: /* ((u32) dst == (u32) src) */
  1215			mask = 0x8000; /* je */
  1216			goto branch_xu;
  1217		case BPF_JMP | BPF_JSET | BPF_X: /* (dst & src) */
  1218		case BPF_JMP32 | BPF_JSET | BPF_X: /* ((u32) dst & (u32) src) */
  1219		{
  1220			bool is_jmp32 = BPF_CLASS(insn->code) == BPF_JMP32;
  1221	
  1222			mask = 0x7000; /* jnz */
  1223			/* nrk or ngrk %w1,%dst,%src */
  1224			EMIT4_RRF((is_jmp32 ? 0xb9f40000 : 0xb9e40000),
  1225				  REG_W1, dst_reg, src_reg);
  1226			goto branch_oc;
  1227	branch_ks:
  1228			is_jmp32 = BPF_CLASS(insn->code) == BPF_JMP32;
  1229			/* lgfi %w1,imm (load sign extend imm) */
  1230			EMIT6_IMM(0xc0010000, REG_W1, imm);
  1231			/* crj or cgrj %dst,%w1,mask,off */
  1232			EMIT6_PCREL(0xec000000, (is_jmp32 ? 0x0076 : 0x0064),
  1233				    dst_reg, REG_W1, i, off, mask);
  1234			break;
  1235	branch_ku:
  1236			is_jmp32 = BPF_CLASS(insn->code) == BPF_JMP32;
  1237			/* lgfi %w1,imm (load sign extend imm) */
  1238			EMIT6_IMM(0xc0010000, REG_W1, imm);
  1239			/* clrj or clgrj %dst,%w1,mask,off */
  1240			EMIT6_PCREL(0xec000000, (is_jmp32 ? 0x0077 : 0x0065),
  1241				    dst_reg, REG_W1, i, off, mask);
  1242			break;
  1243	branch_xs:
  1244			is_jmp32 = BPF_CLASS(insn->code) == BPF_JMP32;
  1245			/* crj or cgrj %dst,%src,mask,off */
  1246			EMIT6_PCREL(0xec000000, (is_jmp32 ? 0x0076 : 0x0064),
  1247				    dst_reg, src_reg, i, off, mask);
  1248			break;
  1249	branch_xu:
  1250			is_jmp32 = BPF_CLASS(insn->code) == BPF_JMP32;
  1251			/* clrj or clgrj %dst,%src,mask,off */
  1252			EMIT6_PCREL(0xec000000, (is_jmp32 ? 0x0077 : 0x0065),
  1253				    dst_reg, src_reg, i, off, mask);
  1254			break;
  1255	branch_oc:
  1256			/* brc mask,jmp_off (branch instruction needs 4 bytes) */
  1257			jmp_off = addrs[i + off + 1] - (addrs[i + 1] - 4);
  1258			EMIT4_PCREL(0xa7040000 | mask << 8, jmp_off);
  1259			break;
  1260		}
  1261		default: /* too complex, give up */
  1262			pr_err("Unknown opcode %02x\n", insn->code);
  1263			return -1;
  1264		}
  1265		return insn_count;
  1266	}
  1267	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--jI8keyz6grp/JLjh
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--jI8keyz6grp/JLjh--
